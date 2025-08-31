import { defineConfig } from 'vite';
import { resolve } from 'path';

// Minimal Vite config to build a static HTML site from index.html
export default defineConfig({
  root: '.',
  publicDir: 'public',
  server: { host: '0.0.0.0', port: 5173 },
  preview: { host: '0.0.0.0', port: 4173 },
  build: {
    rollupOptions: {
      input: resolve(__dirname, 'index.html')
    }
  }
});
