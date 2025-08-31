@echo off
echo ========================================
echo Hope & Harmony Foundation - Quick Deploy
echo ========================================
echo.

REM Check if we're in the right directory
if not exist "package.json" (
    echo [ERROR] package.json not found. Please run this script from the project root.
    pause
    exit /b 1
)

echo [INFO] Starting quick deployment...
echo.

REM Check Node.js
echo [INFO] Checking Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed. Please install Node.js 18+ first.
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)
echo [SUCCESS] Node.js found.

REM Check npm
echo [INFO] Checking npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm is not installed.
    pause
    exit /b 1
)
echo [SUCCESS] npm found.

REM Install dependencies
echo [INFO] Installing dependencies...
npm install
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies installed.

REM Build project
echo [INFO] Building project...
npm run build
if errorlevel 1 (
    echo [ERROR] Build failed.
    pause
    exit /b 1
)
echo [SUCCESS] Build completed.

REM Check if Vercel CLI is installed
echo [INFO] Checking Vercel CLI...
vercel --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Vercel CLI not found. Installing...
    npm install -g vercel
)

echo.
echo ========================================
echo Choose deployment option:
echo ========================================
echo 1. Deploy to Production (vercel --prod)
echo 2. Deploy to Staging (vercel)
echo 3. Start Development Server (npm run dev)
echo 4. Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo [INFO] Deploying to production...
    vercel --prod
    if errorlevel 1 (
        echo [ERROR] Production deployment failed.
    ) else (
        echo [SUCCESS] Production deployment completed!
    )
) else if "%choice%"=="2" (
    echo [INFO] Deploying to staging...
    vercel
    if errorlevel 1 (
        echo [ERROR] Staging deployment failed.
    ) else (
        echo [SUCCESS] Staging deployment completed!
    )
) else if "%choice%"=="3" (
    echo [INFO] Starting development server...
    echo [INFO] Server will be available at: http://localhost:3000
    echo [INFO] Press Ctrl+C to stop the server
    npm run dev
) else if "%choice%"=="4" (
    echo [INFO] Exiting...
    exit /b 0
) else (
    echo [ERROR] Invalid choice. Please enter 1-4.
)

echo.
echo [INFO] Deployment process completed!
echo [INFO] Don't forget to test your deployment!
echo.
pause
