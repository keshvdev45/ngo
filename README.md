# Hope & Harmony Foundation - NGO Website

A modern, responsive website for the Hope & Harmony Foundation NGO, dedicated to community upliftment through education, health, and compassion.

## 🌟 Features

- **Responsive Design**: Mobile-first approach with modern UI/UX
- **Multi-page Website**: About, Updates, Gallery, Contact, Inspiration, and Founder pages
- **Performance Optimized**: Fast loading with optimized assets
- **SEO Friendly**: Meta tags, structured data, and accessibility features
- **Contact Form**: Functional contact form with validation
- **Image Gallery**: Beautiful photo gallery showcasing NGO activities
- **Health Monitoring**: Built-in health check endpoint for monitoring

## 🚀 Quick Start

### Prerequisites

- Node.js >= 18.0.0
- npm >= 9.0.0
- Python 3.8+ (for deployment scripts)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/hope-harmony-foundation.git
   cd hope-harmony-foundation
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Install Python dependencies (for deployment)**
   ```bash
   pip install -r requirements.txt
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

5. **Open your browser**
   ```
   http://localhost:3000
   ```

## 📁 Project Structure

```
hope-harmony-foundation/
├── public/                 # Static assets
│   ├── logo.png
│   ├── father.jpg
│   ├── son.jpg
│   └── hindi_logo.jpg
├── src/                    # Source files
│   ├── components/         # React components
│   ├── pages/             # Page components
│   ├── styles/            # CSS files
│   └── utils/             # Utility functions
├── api/                   # API endpoints
│   └── keep_alive.py      # Health check endpoint
├── dist/                  # Build output
├── docs/                  # Documentation
├── scripts/               # Deployment scripts
├── .github/               # GitHub workflows
├── deployment.yml         # Server configuration
├── deploy.py              # Deployment script
├── vercel.json            # Vercel configuration
├── package.json           # Node.js dependencies
├── requirements.txt       # Python dependencies
└── README.md             # This file
```

## 🚀 Deployment

### Deploy to Vercel (Recommended)

1. **Connect to Vercel**
   ```bash
   npm install -g vercel
   vercel login
   ```

2. **Deploy using our script**
   ```bash
   python deploy.py production
   ```

3. **Or deploy manually**
   ```bash
   npm run build
   vercel --prod
   ```

### Deploy to Other Platforms

The project includes configuration for multiple deployment platforms:

- **Vercel**: `python deploy.py production`
- **Staging**: `python deploy.py staging`
- **Development**: `python deploy.py development`

### Environment Variables

Set these environment variables in your deployment platform:

```env
NODE_ENV=production
CONTACT_EMAIL=kailashmargforhumanity@gmail.com
PHONE_NUMBER=+91 94311 07102
GA_TRACKING_ID=your-google-analytics-id
```

## 🛠️ Development

### Available Scripts

```bash
# Development
npm run dev              # Start development server
npm run build           # Build for production
npm run preview         # Preview production build

# Code Quality
npm run lint           # Run ESLint
npm run lint:fix       # Fix linting issues
npm run type-check     # TypeScript type checking

# Testing
npm run test           # Run tests
npm run test:ui        # Run tests with UI
npm run test:coverage  # Run tests with coverage

# Deployment
npm run deploy:staging    # Deploy to staging
npm run deploy:production # Deploy to production
```

### Adding New Pages

1. Create a new HTML file in the root directory
2. Add it to `vercel.json` builds section
3. Update navigation in `index.html`
4. Add to `deployment.yml` static files list

### Adding New API Endpoints

1. Create a new Python file in the `api/` directory
2. Add it to `vercel.json` builds section
3. Update `deployment.yml` API configuration

## 📊 Monitoring & Health Checks

The website includes built-in monitoring:

- **Health Check Endpoint**: `/api/keep_alive`
- **Response**: `{"status":"ok","service":"keep-alive"}`

Monitor your deployment:
```bash
curl https://your-domain.vercel.app/api/keep_alive
```

## 🔧 Configuration

### deployment.yml

This file contains all server configurations:

- **Server Types**: Vercel, local development
- **Environment Variables**: Per-environment settings
- **Build Settings**: Framework and build commands
- **Security**: CORS, rate limiting, headers
- **Monitoring**: Health checks and uptime monitoring
- **Performance**: Caching and compression settings

### vercel.json

Vercel-specific configuration:

- **Builds**: Static file and API endpoint builds
- **Routes**: URL routing and redirects
- **Headers**: Security and performance headers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes
4. Test thoroughly: `npm run test`
5. Commit your changes: `git commit -am 'Add new feature'`
6. Push to the branch: `git push origin feature/new-feature`
7. Submit a pull request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

- **Email**: kailashmargforhumanity@gmail.com
- **Phone**: +91 94311 07102
- **Location**: Ranchi, Jharkhand, India

## 🙏 Acknowledgments

- Built with love for the Hope & Harmony Foundation
- Inspired by the founder's father's vision of service to humanity
- Dedicated to community upliftment and social welfare

---

**Together, we rise to make a difference.** 🌟
