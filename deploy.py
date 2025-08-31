#!/usr/bin/env python3
"""
Deployment script for Hope & Harmony Foundation NGO website
Uses deployment.yml configuration to deploy to multiple servers
"""

import yaml
import os
import sys
import subprocess
import requests
import time
from pathlib import Path
from typing import Dict, Any, List

class Deployer:
    def __init__(self, config_file: str = "deployment.yml"):
        self.config_file = config_file
        self.config = self.load_config()
        
    def load_config(self) -> Dict[str, Any]:
        """Load YAML configuration file"""
        try:
            with open(self.config_file, 'r', encoding='utf-8') as file:
                return yaml.safe_load(file)
        except FileNotFoundError:
            print(f"❌ Configuration file {self.config_file} not found!")
            sys.exit(1)
        except yaml.YAMLError as e:
            print(f"❌ Error parsing YAML configuration: {e}")
            sys.exit(1)
    
    def get_server_config(self, server_name: str) -> Dict[str, Any]:
        """Get configuration for a specific server"""
        if server_name not in self.config.get('servers', {}):
            print(f"❌ Server '{server_name}' not found in configuration!")
            print(f"Available servers: {list(self.config.get('servers', {}).keys())}")
            sys.exit(1)
        return self.config['servers'][server_name]
    
    def run_command(self, command: str, cwd: str = None) -> bool:
        """Run a shell command and return success status"""
        try:
            print(f"🔄 Running: {command}")
            result = subprocess.run(
                command, 
                shell=True, 
                cwd=cwd or os.getcwd(),
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                print(f"✅ Command completed successfully")
                if result.stdout:
                    print(f"Output: {result.stdout}")
                return True
            else:
                print(f"❌ Command failed with return code {result.returncode}")
                if result.stderr:
                    print(f"Error: {result.stderr}")
                return False
        except Exception as e:
            print(f"❌ Error running command: {e}")
            return False
    
    def pre_deploy_checks(self, server_config: Dict[str, Any]) -> bool:
        """Run pre-deployment checks"""
        print("🔍 Running pre-deployment checks...")
        
        # Check if required files exist
        static_files = self.config.get('storage', {}).get('static_files', [])
        for file in static_files:
            if not os.path.exists(file):
                print(f"❌ Required file not found: {file}")
                return False
        
        # Check if package.json exists for npm commands
        if not os.path.exists('package.json'):
            print("❌ package.json not found!")
            return False
        
        print("✅ Pre-deployment checks passed")
        return True
    
    def run_pre_deploy_scripts(self, server_config: Dict[str, Any]) -> bool:
        """Run pre-deployment scripts"""
        scripts = self.config.get('deployment_scripts', {}).get('pre_deploy', [])
        if not scripts:
            return True
        
        print("📦 Running pre-deployment scripts...")
        for script in scripts:
            if not self.run_command(script):
                print(f"❌ Pre-deployment script failed: {script}")
                return False
        
        return True
    
    def deploy_to_vercel(self, server_config: Dict[str, Any]) -> bool:
        """Deploy to Vercel"""
        print(f"🚀 Deploying to Vercel: {server_config.get('domain', 'Unknown')}")
        
        # Set environment variables
        env_vars = server_config.get('environment_variables', {})
        for key, value in env_vars.items():
            os.environ[key] = value
        
        # Run build command
        build_command = server_config.get('build_settings', {}).get('build_command', 'npm run build')
        if not self.run_command(build_command):
            return False
        
        # Deploy to Vercel
        deploy_command = "vercel --prod" if server_config.get('name') == 'Production' else "vercel"
        if not self.run_command(deploy_command):
            return False
        
        return True
    
    def deploy_to_local(self, server_config: Dict[str, Any]) -> bool:
        """Deploy to local development server"""
        print(f"🚀 Starting local development server...")
        
        dev_command = server_config.get('build_settings', {}).get('dev_command', 'npm run dev')
        port = server_config.get('build_settings', {}).get('port', 3000)
        
        print(f"📡 Server will be available at: http://localhost:{port}")
        print("⚠️  Press Ctrl+C to stop the server")
        
        try:
            subprocess.run(dev_command, shell=True)
        except KeyboardInterrupt:
            print("\n🛑 Development server stopped")
        
        return True
    
    def health_check(self, server_config: Dict[str, Any]) -> bool:
        """Perform health check on deployed server"""
        print("🏥 Performing health check...")
        
        domain = server_config.get('domain', '')
        if not domain:
            print("❌ No domain specified for health check")
            return False
        
        health_endpoint = self.config.get('monitoring', {}).get('health_check', {}).get('endpoint', '/api/keep_alive')
        url = f"https://{domain}{health_endpoint}"
        
        try:
            response = requests.get(url, timeout=10)
            if response.status_code == 200:
                print(f"✅ Health check passed: {url}")
                return True
            else:
                print(f"❌ Health check failed: {url} returned {response.status_code}")
                return False
        except requests.RequestException as e:
            print(f"❌ Health check failed: {e}")
            return False
    
    def run_post_deploy_scripts(self, server_config: Dict[str, Any]) -> bool:
        """Run post-deployment scripts"""
        scripts = self.config.get('deployment_scripts', {}).get('post_deploy', [])
        if not scripts:
            return True
        
        print("🎉 Running post-deployment scripts...")
        for script in scripts:
            if not self.run_command(script):
                print(f"⚠️  Post-deployment script failed: {script}")
                # Don't fail deployment for post-deploy script failures
        
        return True
    
    def deploy(self, server_name: str) -> bool:
        """Main deployment method"""
        print(f"🎯 Starting deployment to {server_name}...")
        
        server_config = self.get_server_config(server_name)
        
        # Pre-deployment checks
        if not self.pre_deploy_checks(server_config):
            return False
        
        # Pre-deployment scripts
        if not self.run_pre_deploy_scripts(server_config):
            return False
        
        # Deploy based on server type
        server_type = server_config.get('type', 'unknown')
        if server_type == 'vercel':
            success = self.deploy_to_vercel(server_config)
        elif server_type == 'local':
            success = self.deploy_to_local(server_config)
        else:
            print(f"❌ Unknown server type: {server_type}")
            return False
        
        if not success:
            return False
        
        # Health check (only for remote servers)
        if server_type != 'local':
            if not self.health_check(server_config):
                print("⚠️  Health check failed, but deployment may still be successful")
        
        # Post-deployment scripts
        self.run_post_deploy_scripts(server_config)
        
        print(f"🎉 Deployment to {server_name} completed!")
        return True
    
    def list_servers(self):
        """List all available servers"""
        servers = self.config.get('servers', {})
        print("📋 Available servers:")
        for name, config in servers.items():
            server_type = config.get('type', 'unknown')
            domain = config.get('domain', 'No domain')
            print(f"  • {name} ({server_type}): {domain}")

def main():
    if len(sys.argv) < 2:
        print("Usage: python deploy.py <server_name>")
        print("       python deploy.py list")
        print("\nExamples:")
        print("  python deploy.py production")
        print("  python deploy.py staging")
        print("  python deploy.py development")
        print("  python deploy.py list")
        sys.exit(1)
    
    command = sys.argv[1]
    deployer = Deployer()
    
    if command == "list":
        deployer.list_servers()
    else:
        success = deployer.deploy(command)
        sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
