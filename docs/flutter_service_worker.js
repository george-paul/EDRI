'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "1f66818982170fd60636cff5e0e35c32",
"assets/assets/fonts/Arvo-Bold.ttf": "ab1dabbd8ffd289a5c35cb151879e987",
"assets/assets/fonts/Arvo-BoldItalic.ttf": "a53d4514f91e2a95842412c4d3954dd0",
"assets/assets/fonts/Arvo-Italic.ttf": "4d7f205bc8a4a7e98c219a1427999533",
"assets/assets/fonts/Arvo-Regular.ttf": "afb50701726581f5f817faab8f7cf1b7",
"assets/assets/images/ihub.png": "4672e04e0f687b7f001c5b6f549cc8c5",
"assets/assets/images/iiit.png": "b2bd9e6b52d6f6468ae67f3b6f20678a",
"assets/assets/images/inai.png": "7046a1da73b4aa14a36b6613b8547d36",
"assets/assets/images/logo.png": "2ad78c24ad82aa99da5e1337430c7da8",
"assets/assets/images/surveyImage0.png": "fac84a977d727fdbfcc0d4f6f933caba",
"assets/assets/images/surveyImage1.png": "d1490aa1800864f3f340fee0a79ef81b",
"assets/assets/images/surveyImage2.png": "1af93d25fab795a9f71b3cc037baadde",
"assets/FontManifest.json": "687bba46a655d9ed2d1a6f98d7aed813",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "ed98fd4aac5da34033930adfa8c6429c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/shaders/ink_sparkle.frag": "998c7d2a66ae16afab37626e752cf0ea",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"icons/android-icon-144x144.png": "aad1362f2360817b51d916dc1e0ba173",
"icons/android-icon-192x192.png": "8cc929488dc17e8dd26df33da9a54b67",
"icons/android-icon-36x36.png": "8200b30ceee3ce0cb1a7e989ee01b967",
"icons/android-icon-48x48.png": "2ae14b3f886eadbf5e9ccff25d88aabc",
"icons/android-icon-72x72.png": "aaba7182ec21d0a4c3a40549a3c3acf5",
"icons/android-icon-96x96.png": "607d0641d10aa3356f65f5a2e222e6fe",
"icons/apple-icon-114x114.png": "c81c2d247639b6ab5172eae5a2ff5f0d",
"icons/apple-icon-120x120.png": "7549827653c434e67f4284836cfc64e3",
"icons/apple-icon-144x144.png": "aad1362f2360817b51d916dc1e0ba173",
"icons/apple-icon-152x152.png": "b90e46790bc189407e0adca094a42d36",
"icons/apple-icon-180x180.png": "6b51b9b0d03ad4d681775a840ecb3708",
"icons/apple-icon-57x57.png": "fc049c860ffb1030b97e153a4b3e9d43",
"icons/apple-icon-60x60.png": "ddb6473ac293a7d05319a39b49420174",
"icons/apple-icon-72x72.png": "aaba7182ec21d0a4c3a40549a3c3acf5",
"icons/apple-icon-76x76.png": "a3731e0fab1f201a903c676025837a4b",
"icons/apple-icon-precomposed.png": "fea101b276b0ec547b8a3af29cadcdaf",
"icons/apple-icon.png": "fea101b276b0ec547b8a3af29cadcdaf",
"icons/favicon-16x16.png": "3662ed46946bae57ff191e1f7fb4489d",
"icons/favicon-32x32.png": "2f5856d6f8b85cfb8986b54102ed08d1",
"icons/favicon-96x96.png": "607d0641d10aa3356f65f5a2e222e6fe",
"icons/favicon.ico": "31d2126a5add40d56efcfe5f20e0c707",
"icons/ms-icon-144x144.png": "aad1362f2360817b51d916dc1e0ba173",
"icons/ms-icon-150x150.png": "76eacb106d05d9e5a86a0b71f3683c4c",
"icons/ms-icon-310x310.png": "7ab1a8d05455005e5f622396b51da454",
"icons/ms-icon-70x70.png": "d23a8f6369a8da74b657efb3fa58a29d",
"index.html": "cc83a5cb5094fd0d921f09900e9bc7d9",
"/": "cc83a5cb5094fd0d921f09900e9bc7d9",
"main.dart.js": "695df74bda7923feb13faccf6a895dfb",
"manifest.json": "b180c333e40852ee88cbc1ccbcc21b5c",
"version.json": "2ccb0153bb8fe360e3b0dbcc9ebaa7ba"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
