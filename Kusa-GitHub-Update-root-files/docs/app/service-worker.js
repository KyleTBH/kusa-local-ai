const CACHE = 'kusa-pwa-v0.10.8';
const APP_FILES = ['./', './index.html', './app.js?v=0.10.8', './style.css?v=0.10.8', './manifest.webmanifest', './favicon.svg', './assets/icon-192.png', './assets/icon-512.png', './assets/logo-transparent.png'];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(APP_FILES)).then(() => self.skipWaiting()));
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key !== CACHE).map(key => caches.delete(key)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', event => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || url.origin !== self.location.origin || url.pathname.includes('/api/')) return;
  event.respondWith(fetch(request).then(response => {
    if (response.ok && (request.mode === 'navigate' || /\.(?:js|css|svg|png|webmanifest)$/.test(url.pathname))) {
      const copy = response.clone();
      caches.open(CACHE).then(cache => cache.put(request, copy));
    }
    return response;
  }).catch(async () => (await caches.match(request)) || (request.mode === 'navigate' ? caches.match('./index.html') : undefined)));
});
