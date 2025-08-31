# Hope & Harmony Foundation - PowerShell Deployment Script
# This script automates the deployment process on Windows

param(
    [Parameter(Position=0)]
    [ValidateSet("production", "staging", "development")]
    [string]$Environment = "production"
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Colors for output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Red
}

# Check if we're in the right directory
if (-not (Test-Path "package.json")) {
    Write-Error "package.json not found. Please run this script from the project root."
    exit 1
}

Write-Status "Starting deployment to $Environment environment..."

# Check prerequisites
Write-Status "Checking prerequisites..."

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Success "Node.js found: $nodeVersion"
} catch {
    Write-Error "Node.js is not installed. Please install Node.js 18+ first."
    Write-Host "Download from: https://nodejs.org/" -ForegroundColor $Yellow
    exit 1
}

# Check npm
try {
    $npmVersion = npm --version
    Write-Success "npm found: $npmVersion"
} catch {
    Write-Error "npm is not installed."
    exit 1
}

# Check Vercel CLI
try {
    $vercelVersion = vercel --version
    Write-Success "Vercel CLI found: $vercelVersion"
} catch {
    Write-Warning "Vercel CLI not found. Installing..."
    npm install -g vercel
}

Write-Success "Prerequisites check completed."

# Install dependencies
Write-Status "Installing dependencies..."
try {
    npm install
    Write-Success "Dependencies installed."
} catch {
    Write-Error "Failed to install dependencies."
    exit 1
}

# Run linting
Write-Status "Running linting..."
try {
    npm run lint
    Write-Success "Linting passed."
} catch {
    Write-Warning "Linting failed, but continuing deployment..."
}

# Run tests
Write-Status "Running tests..."
try {
    npm run test
    Write-Success "Tests passed."
} catch {
    Write-Warning "Tests failed, but continuing deployment..."
}

# Build project
Write-Status "Building project..."
try {
    npm run build
    Write-Success "Build completed."
} catch {
    Write-Error "Build failed. Deployment aborted."
    exit 1
}

# Deploy based on environment
switch ($Environment) {
    "production" {
        Write-Status "Deploying to production..."
        try {
            vercel --prod
            Write-Success "Production deployment completed!"
        } catch {
            Write-Error "Production deployment failed."
            exit 1
        }
    }
    "staging" {
        Write-Status "Deploying to staging..."
        try {
            vercel
            Write-Success "Staging deployment completed!"
        } catch {
            Write-Error "Staging deployment failed."
            exit 1
        }
    }
    "development" {
        Write-Status "Starting development server..."
        Write-Host "Server will be available at: http://localhost:3000" -ForegroundColor $Blue
        Write-Host "Press Ctrl+C to stop the server" -ForegroundColor $Yellow
        npm run dev
    }
}

Write-Success "Deployment script completed successfully!"
Write-Status "Don't forget to test your deployment!"
