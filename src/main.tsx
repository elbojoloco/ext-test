import { render } from 'preact'
import { App } from './app.tsx'

// Create or get mount point element
let mountElement = document.getElementById('ext-app')
if (!mountElement) {
  mountElement = document.createElement('div')
  mountElement.id = 'ext-app'
  document.body.appendChild(mountElement)
}

render(<App />, mountElement)
