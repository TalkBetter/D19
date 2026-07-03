"use strict";

// 版本號：改動 app shell 後遞增即可更新快取
var CACHE = "bishun-v4";

// 離線可用的 app 殼層（同網域檔案）
var SHELL = ["./w.html", "./manifest.json", "./icon.svg"];

self.addEventListener("install", function (e) {
  e.waitUntil(
    caches.open(CACHE).then(function (c) {
      return c.addAll(SHELL);
    }).then(function () {
      return self.skipWaiting();
    })
  );
});

self.addEventListener("activate", function (e) {
  e.waitUntil(
    caches.keys().then(function (keys) {
      return Promise.all(keys.filter(function (k) {
        return k !== CACHE;
      }).map(function (k) {
        return caches.delete(k);
      }));
    }).then(function () {
      return self.clients.claim();
    })
  );
});

// 快取優先；遠端的筆順 GIF 與讀音 MP3 看過一次後會被存起來，之後可離線重看
self.addEventListener("fetch", function (e) {
  var req = e.request;
  if (req.method !== "GET") { return; }

  // 音檔/影音的 Range 請求交給瀏覽器原生處理：
  // iOS 播放 mp3 會先發 Range 請求並要求正確的 206 回應，
  // 從快取回 200 完整檔會導致 iOS 拒絕播放
  if (req.headers.get("range")) { return; }

  e.respondWith(
    caches.match(req).then(function (cached) {
      if (cached) { return cached; }

      return fetch(req).then(function (res) {
        var url = req.url;
        var cacheable = res && (res.ok || res.type === "opaque") &&
          (url.indexOf("twpen.com") > -1 ||
           url.indexOf("learningweb.moe.edu.tw") > -1 ||
           url.indexOf(self.location.origin) === 0);
        if (cacheable) {
          var copy = res.clone();
          caches.open(CACHE).then(function (c) { c.put(req, copy); });
        }
        return res;
      }).catch(function () {
        return cached;
      });
    })
  );
});
