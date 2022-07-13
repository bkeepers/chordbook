import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { VitePWA } from 'vite-plugin-pwa'
import svgLoader from 'vite-svg-loader'
import { string } from 'rollup-plugin-string'
import manifest from './client/manifest.json'
import path from 'path'

const root = path.resolve(__dirname, 'client')

// https://vitejs.dev/config/
export default defineConfig({
  envDir: __dirname,
  envPrefix: 'APP',
  root,
  build: {
    sourcemap: true,
    outDir: path.resolve(__dirname, 'public'),
    emptyOutDir: true
  },
  plugins: [
    vue(),
    svgLoader(),
    VitePWA({
      registerType: 'autoUpdate',
      srcDir: 'service_workers',
      filename: 'offline.js',
      workbox: {
        sourcemap: true
      },
      manifest
    }),
    string({ include: '**/*.snippets' })
  ],
  resolve: {
    alias: {
      '@': path.resolve(root, 'src')
    }
  },
  test: {
    globals: true,
    environment: 'jsdom'
  }
})
