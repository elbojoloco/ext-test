import tailwindcss from '@tailwindcss/vite'
import preact from '@preact/preset-vite'
import { defineConfig } from 'vite'
import { inlineCss } from './vite-plugin-inline-css'

// https://vite.dev/config/
export default defineConfig({
  plugins: [tailwindcss(), preact(), inlineCss()],
  build: {
    rollupOptions: {
      output: {
        format: 'iife',
        entryFileNames: 'ext.js',
        inlineDynamicImports: true,
        assetFileNames: 'ext.[ext]',
      },
    },
    outDir: 'dist',
    cssCodeSplit: false,
  },
})
