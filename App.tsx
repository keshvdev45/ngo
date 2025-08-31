// Enterprise-grade React application for Fathers Vision NGO
// This component orchestrates the entire application with advanced routing, state management, and security features

import React, { Suspense, useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { HelmetProvider } from 'react-helmet-async';
import { Toaster } from 'react-hot-toast';
import { motion, AnimatePresence } from 'framer-motion';

// Import i18n configuration
import './i18n';

// Core configuration and utilities
import { loadConfig, configManager } from './config';
import { FathersVisionConfig } from './types/config';

// Layout components
import { Navigation } from './components/layout/Navigation';
import { Footer } from './components/layout/Footer';

// Page components (lazy loaded for performance)
const HomePage = React.lazy(() => import('./pages/HomePage'));

// Application state interface
interface AppState {
  config: FathersVisionConfig | null;
  isLoading: boolean;
  error: Error | null;
  maintenanceMode: boolean;
  currentLanguage: string;
}

// Main App component
const App: React.FC = () => {
  // Application state
  const [appState, setAppState] = useState<AppState>({
    config: null,
    isLoading: true,
    error: null,
    maintenanceMode: false,
    currentLanguage: 'en'
  });

  // Load configuration on mount
  useEffect(() => {
    const initializeApp = async () => {
      try {
        const config = await loadConfig();
        setAppState(prev => ({
          ...prev,
          config,
          isLoading: false
        }));
      } catch (error) {
        console.error('Failed to load configuration:', error);
        setAppState(prev => ({
          ...prev,
          error: error as Error,
          isLoading: false
        }));
      }
    };

    initializeApp();
  }, []);

  // Show loading state
  if (appState.isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center">
          <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-primary-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading Father's Vision...</p>
        </div>
      </div>
    );
  }

  // Show error state
  if (appState.error) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center p-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            Configuration Error
          </h1>
          <p className="text-gray-600 mb-4">
            Failed to load application configuration. Please refresh the page.
          </p>
          <button
            onClick={() => window.location.reload()}
            className="bg-primary-600 text-white px-4 py-2 rounded hover:bg-primary-700"
          >
            Refresh Page
          </button>
        </div>
      </div>
    );
  }

  // Show maintenance mode
  if (appState.maintenanceMode) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-center p-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            Under Maintenance
          </h1>
          <p className="text-gray-600">
            We're currently updating our website. Please check back soon.
          </p>
        </div>
      </div>
    );
  }

  return (
    <HelmetProvider>
      <QueryClientProvider client={new QueryClient()}>
        <Router>
          <div className="min-h-screen bg-white">
            {/* Navigation */}
            <Navigation />
            
            {/* Main Content */}
            <main className="pt-20">
              <Suspense fallback={
                <div className="min-h-screen flex items-center justify-center">
                  <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-primary-600"></div>
                </div>
              }>
                <Routes>
                  <Route path="/" element={<HomePage />} />
                  <Route path="*" element={<Navigate to="/" replace />} />
                </Routes>
              </Suspense>
            </main>

            {/* Footer */}
            <Footer />
          </div>
        </Router>
        
        {/* Toast notifications */}
        <Toaster 
          position="top-right"
          toastOptions={{
            duration: 4000,
            style: {
              background: '#363636',
              color: '#fff',
            },
          }}
        />
      </QueryClientProvider>
    </HelmetProvider>
  );
};

export default App;
