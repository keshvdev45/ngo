# 🚀 Quick Setup Guide - Hope & Harmony Foundation

## 📋 Prerequisites

Before you start, make sure you have:

- **Node.js 18+** installed ([Download here](https://nodejs.org/))
- **npm** (comes with Node.js)
- **Git** for version control

## 🛠️ Quick Start (No Python Required)

### Option 1: Use the Quick Deploy Script (Recommended)

1. **Double-click** `quick-deploy.bat` in your project folder
2. **Choose your deployment option**:
   - Option 1: Deploy to Production
   - Option 2: Deploy to Staging  
   - Option 3: Start Development Server
   - Option 4: Exit

### Option 2: Use PowerShell Script

1. **Open PowerShell** in your project folder
2. **Run one of these commands**:
   ```powershell
   # Deploy to production
   .\deploy.ps1 production
   
   # Deploy to staging
   .\deploy.ps1 staging
   
   # Start development server
   .\deploy.ps1 development
   ```

### Option 3: Manual Commands

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Build the project**:
   ```bash
   npm run build
   ```

3. **Deploy to Vercel**:
   ```bash
   # Install Vercel CLI (if not installed)
   npm install -g vercel
   
   # Login to Vercel (first time only)
   vercel login
   
   # Deploy to production
   vercel --prod
   ```

## 🌐 Deploy to GitHub

### Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Click "New repository"
3. Name it: `hope-harmony-foundation`
4. Make it public
5. Don't initialize with README (we already have one)

### Step 2: Push Your Code

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit changes
git commit -m "Initial commit: Hope & Harmony Foundation website"

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/hope-harmony-foundation.git

# Push to GitHub
git push -u origin main
```

### Step 3: Connect to Vercel

1. Go to [Vercel.com](https://vercel.com)
2. Sign up/Login with GitHub
3. Click "New Project"
4. Import your `hope-harmony-foundation` repository
5. Deploy!

## 🔧 Environment Variables

Set these in your Vercel dashboard:

```
NODE_ENV=production
CONTACT_EMAIL=kailashmargforhumanity@gmail.com
PHONE_NUMBER=+91 94311 07102
GA_TRACKING_ID=your-google-analytics-id
```

## 📁 Project Structure

```
hope-harmony-foundation/
├── public/                 # Images and static assets
│   ├── logo.png
│   ├── father.jpg
│   ├── son.jpg
│   └── hindi_logo.jpg
├── api/                    # API endpoints
│   └── keep_alive.py       # Health check
├── docs/                   # Documentation
├── scripts/                # Deployment scripts
├── .github/workflows/      # GitHub Actions
├── index.html              # Main page
├── about.html              # About page
├── contact.html            # Contact page
├── gallery.html            # Gallery page
├── updates.html            # Updates page
├── inspiration.html        # Inspiration page
├── founder.html            # Founder page
├── site.css                # Styles
├── package.json            # Dependencies
├── vercel.json             # Vercel config
├── deployment.yml          # Server config
├── quick-deploy.bat        # Windows deployment
├── deploy.ps1              # PowerShell deployment
└── README.md               # This file
```

## 🚨 Troubleshooting

### Common Issues:

1. **"Node.js not found"**
   - Download and install Node.js from [nodejs.org](https://nodejs.org/)

2. **"npm not found"**
   - npm comes with Node.js, reinstall Node.js

3. **"Build failed"**
   - Check if all files are in the right place
   - Make sure images are in the `public/` folder

4. **"Vercel not found"**
   - Run: `npm install -g vercel`

5. **"Permission denied"**
   - Run PowerShell as Administrator

## 📞 Need Help?

- **Email**: kailashmargforhumanity@gmail.com
- **Phone**: +91 94311 07102
- **Location**: Ranchi, Jharkhand, India

## 🎯 Next Steps

1. **Test your deployment** at your Vercel URL
2. **Add your custom domain** in Vercel settings
3. **Set up Google Analytics** for tracking
4. **Configure monitoring** for uptime alerts
5. **Share your website** with your community!

---

**Together, we rise to make a difference.** 🌟
