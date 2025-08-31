@echo off
REM Hope & Harmony Foundation - Deployment Script for Windows
REM This script automates the deployment process on Windows

setlocal enabledelayedexpansion

REM Set colors for output
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

REM Function to print colored output
:print_status
echo %BLUE%[INFO]%NC% %~1
goto :eof

:print_success
echo %GREEN%[SUCCESS]%NC% %~1
goto :eof

:print_warning
echo %YELLOW%[WARNING]%NC% %~1
goto :eof

:print_error
echo %RED%[ERROR]%NC% %~1
goto :eof

REM Check if we're in the right directory
if not exist "package.json" (
    call :print_error "package.json not found. Please run this script from the project root."
    exit /b 1
)

REM Parse command line arguments
set "ENVIRONMENT=%1"
if "%ENVIRONMENT%"=="" set "ENVIRONMENT=production"

call :print_status "Starting deployment to %ENVIRONMENT% environment..."

REM Check prerequisites
call :print_status "Checking prerequisites..."

REM Check Node.js
node --version >nul 2>&1
if errorlevel 1 (
    call :print_error "Node.js is not installed. Please install Node.js 18+ first."
    exit /b 1
)

REM Check npm
npm --version >nul 2>&1
if errorlevel 1 (
    call :print_error "npm is not installed. Please install npm first."
    exit /b 1
)

REM Check Python (for deployment script)
python --version >nul 2>&1
if errorlevel 1 (
    call :print_warning "Python not found. Some deployment features may not work."
)

REM Check Vercel CLI
vercel --version >nul 2>&1
if errorlevel 1 (
    call :print_warning "Vercel CLI not found. Installing..."
    npm install -g vercel
)

call :print_success "Prerequisites check completed."

REM Install dependencies
call :print_status "Installing dependencies..."
npm ci
if errorlevel 1 (
    call :print_error "Failed to install dependencies."
    exit /b 1
)
call :print_success "Dependencies installed."

REM Run linting
call :print_status "Running linting..."
npm run lint
if errorlevel 1 (
    call :print_warning "Linting failed, but continuing deployment..."
) else (
    call :print_success "Linting passed."
)

REM Run tests
call :print_status "Running tests..."
npm run test
if errorlevel 1 (
    call :print_warning "Tests failed, but continuing deployment..."
) else (
    call :print_success "Tests passed."
)

REM Build project
call :print_status "Building project..."
npm run build
if errorlevel 1 (
    call :print_error "Build failed. Deployment aborted."
    exit /b 1
)
call :print_success "Build completed."

REM Deploy based on environment
if "%ENVIRONMENT%"=="production" (
    call :print_status "Deploying to production..."
    vercel --prod
    if errorlevel 1 (
        call :print_error "Production deployment failed."
        exit /b 1
    )
    call :print_success "Production deployment completed!"
) else if "%ENVIRONMENT%"=="staging" (
    call :print_status "Deploying to staging..."
    vercel
    if errorlevel 1 (
        call :print_error "Staging deployment failed."
        exit /b 1
    )
    call :print_success "Staging deployment completed!"
) else if "%ENVIRONMENT%"=="development" (
    call :print_status "Starting development server..."
    npm run dev
) else (
    call :print_error "Invalid environment: %ENVIRONMENT%"
    call :print_status "Valid options: production, staging, development"
    exit /b 1
)

call :print_success "Deployment script completed successfully!"
call :print_status "Don't forget to test your deployment!"

pause
