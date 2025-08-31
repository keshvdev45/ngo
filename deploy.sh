#!/bin/bash

# Hope & Harmony Foundation - Deployment Script
# This script automates the deployment process

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    print_error "package.json not found. Please run this script from the project root."
    exit 1
fi

# Parse command line arguments
ENVIRONMENT=${1:-production}
VERBOSE=${2:-false}

print_status "Starting deployment to $ENVIRONMENT environment..."

# Check prerequisites
print_status "Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check npm
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

# Check Python (for deployment script)
if ! command -v python3 &> /dev/null; then
    print_warning "Python 3 not found. Some deployment features may not work."
fi

# Check Vercel CLI
if ! command -v vercel &> /dev/null; then
    print_warning "Vercel CLI not found. Installing..."
    npm install -g vercel
fi

print_success "Prerequisites check completed."

# Install dependencies
print_status "Installing dependencies..."
npm ci
print_success "Dependencies installed."

# Run linting
print_status "Running linting..."
if npm run lint; then
    print_success "Linting passed."
else
    print_warning "Linting failed, but continuing deployment..."
fi

# Run tests
print_status "Running tests..."
if npm run test; then
    print_success "Tests passed."
else
    print_warning "Tests failed, but continuing deployment..."
fi

# Build project
print_status "Building project..."
if npm run build; then
    print_success "Build completed."
else
    print_error "Build failed. Deployment aborted."
    exit 1
fi

# Deploy based on environment
case $ENVIRONMENT in
    "production")
        print_status "Deploying to production..."
        if vercel --prod; then
            print_success "Production deployment completed!"
        else
            print_error "Production deployment failed."
            exit 1
        fi
        ;;
    "staging")
        print_status "Deploying to staging..."
        if vercel; then
            print_success "Staging deployment completed!"
        else
            print_error "Staging deployment failed."
            exit 1
        fi
        ;;
    "development")
        print_status "Starting development server..."
        npm run dev
        ;;
    *)
        print_error "Invalid environment: $ENVIRONMENT"
        print_status "Valid options: production, staging, development"
        exit 1
        ;;
esac

print_success "Deployment script completed successfully!"
print_status "Don't forget to test your deployment!"
