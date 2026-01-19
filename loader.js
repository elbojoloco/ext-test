// Create mount point element at the bottom of document.body
let mountElement = document.getElementById('ext-app');
if (!mountElement) {
  mountElement = document.createElement('div');
  mountElement.id = 'ext-app';
  document.body.appendChild(mountElement);
}

// Determine the ext.js source based on data-src attribute or resolve relative to loader
function getExtSource() {
  const currentScript = document.currentScript;
  const customSrc = currentScript?.getAttribute('data-src');
  
  // If a custom source is provided, use it directly
  if (customSrc) {
    return customSrc;
  }
  
  // Default: resolve relative to the loader script's location
  const loaderSrc = currentScript?.src || '';
  const basePath = loaderSrc.substring(0, loaderSrc.lastIndexOf('/') + 1);
  return basePath + 'dist/ext.js';
}

const src = getExtSource();

// Load the script by appending a script tag to document.body
const script = document.createElement('script');
script.src = src;
script.async = true;

script.onload = function() {
  console.log(`ext.js loaded successfully from ${src}`);
};

script.onerror = function() {
  console.error(`Failed to load ext.js from: ${src}`);
};

document.body.appendChild(script);
