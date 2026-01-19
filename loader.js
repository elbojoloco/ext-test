// Create mount point element at the bottom of document.body
let mountElement = document.getElementById('ext-app');
if (!mountElement) {
  mountElement = document.createElement('div');
  mountElement.id = 'ext-app';
  document.body.appendChild(mountElement);
}

// Load the script by appending a script tag to document.body
const script = document.createElement('script');
script.src = 'file:///Users/bojo/Projects/ext-test/dist/ext.js';
script.async = true;

script.onload = function() {
  console.log('ext.js loaded successfully');
};

script.onerror = function() {
  console.error('Failed to load ext.js from:', 'file:///Users/bojo/Projects/ext-test/dist/ext.js');
};

document.body.appendChild(script);
