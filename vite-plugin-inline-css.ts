import type { Plugin } from 'vite';

/**
 * Vite plugin that inlines CSS into the JavaScript bundle
 */
export function inlineCss(): Plugin {
  let cssContent = '';
  let cssFileName = '';

  return {
    name: 'inline-css',
    enforce: 'post',
    
    generateBundle(_options, bundle) {
      // Find the CSS file in the bundle
      for (const fileName in bundle) {
        const chunk = bundle[fileName];
        if (chunk.type === 'asset' && fileName.endsWith('.css')) {
          cssFileName = fileName;
          cssContent = chunk.source as string;
          // Remove the CSS file from the bundle
          delete bundle[fileName];
        }
      }

      // Inject CSS into the JS bundle
      if (cssContent && cssFileName) {
        for (const fileName in bundle) {
          const chunk = bundle[fileName];
          if (chunk.type === 'chunk' && chunk.isEntry) {
            // Inject CSS injection code at the beginning of the bundle
            const cssInjectionCode = `
(function() {
  if (typeof document !== 'undefined') {
    const style = document.createElement('style');
    style.textContent = ${JSON.stringify(cssContent)};
    document.head.appendChild(style);
  }
})();
`;
            chunk.code = cssInjectionCode + chunk.code;
          }
        }
      }
    },
  };
}
