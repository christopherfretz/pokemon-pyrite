/* Kanto First - offline / home-screen support, page side (PW1).
 *
 * Shared by index.html and edit.html.  Registers ./sw.js (the generated
 * service worker, see sw.template.js) and drives three optional elements:
 *   #offline-status  "Offline: ready ✓ (build X)" / "caching…" / "unavailable"
 *   #btn-update      "Update ready – reload", shown when a new build is waiting
 *   #update-badge    a hint next to the menu's summary while one is waiting
 *
 * Rules: registration failure is non-fatal and the page behaves exactly as
 * without a worker; a waiting build is activated ONLY when the player taps the
 * button (never an automatic reload mid-game), after window.kfBeforeUpdate()
 * (app.js: flush the battery save + resume snapshot) has had up to 3 s.  This
 * file does not touch IndexedDB or localStorage.
 */
(function () {
  'use strict';

  var $ = function (sel) { return document.querySelector(sel); };
  var statusEl = null, btn = null, badge = null;
  var reg = null;
  var userAsked = false, reloading = false;
  var lastFailure = '';
  var hadController = false;

  function noop() {}
  function say(text) { if (statusEl) { statusEl.textContent = text; } }

  function ask(worker) {
    return new Promise(function (resolve) {
      if (!worker || typeof MessageChannel !== 'function') { resolve(null); return; }
      var ch = new MessageChannel();
      var t = setTimeout(function () { resolve(null); }, 4000);
      ch.port1.onmessage = function (e) { clearTimeout(t); resolve(e.data || null); };
      try { worker.postMessage({ type: 'kf-info' }, [ch.port2]); } catch (e) { clearTimeout(t); resolve(null); }
    });
  }

  function refresh() {
    if (!reg) { return; }
    var installing = reg.installing;
    var active = reg.active;
    if (!active) {
      say(installing ? 'Offline: caching…'
        : 'Offline: unavailable' + (lastFailure ? ' (' + lastFailure + ')' : ''));
      return;
    }
    ask(active).then(function (inf) {
      if (reg.active !== active) { return; }       // superseded meanwhile
      if (inf && inf.complete) {
        say('Offline: ready ✓ (build ' + inf.build + ')' + (reg.installing ? ' – fetching an update…' : ''));
      } else if (inf) {
        say('Offline: incomplete (' + inf.missing.length + ' files missing) – reload while online');
      } else {
        say(reg.installing ? 'Offline: caching…' : 'Offline: status unknown');
      }
    });
  }

  function showUpdate(worker, label) {
    if (!btn) { return; }
    ask(worker).then(function (inf) {
      btn.textContent = (label || 'Update ready – reload') + (inf && inf.build ? ' (build ' + inf.build + ')' : '');
    });
    btn.hidden = false;
    btn.disabled = false;
    if (badge) { badge.hidden = false; }
  }

  function track(worker) {
    if (!worker) { return; }
    worker.addEventListener('statechange', function () {
      if (worker.state === 'installed' && navigator.serviceWorker.controller) { showUpdate(worker); }
      refresh();
    });
    refresh();
  }

  function check() {
    if (!reg) { return; }
    reg.update().catch(noop);   // rejects offline; that is fine
  }

  function applyUpdate() {
    var waiting = reg && reg.waiting;
    btn.disabled = true;
    if (!waiting) {               // already activated (another tab) - just reload
      reloading = true;
      window.location.reload();
      return;
    }
    userAsked = true;
    btn.textContent = 'Updating…';
    var flush = Promise.resolve();
    try {
      if (typeof window.kfBeforeUpdate === 'function') { flush = Promise.resolve(window.kfBeforeUpdate()); }
    } catch (e) { flush = Promise.resolve(); }
    var timeout = new Promise(function (resolve) { setTimeout(resolve, 3000); });
    Promise.race([flush.catch(noop), timeout]).then(function () {
      waiting.postMessage({ type: 'kf-skip-waiting' });
    });
  }

  function init() {
    statusEl = $('#offline-status');
    btn = $('#btn-update');
    badge = $('#update-badge');
    if (btn) { btn.addEventListener('click', applyUpdate); }

    var sw = navigator.serviceWorker;
    if (!sw || !window.isSecureContext) {
      say('Offline: unavailable (this browser or connection does not allow it)');
      return;
    }
    hadController = !!sw.controller;

    sw.addEventListener('controllerchange', function () {
      if (userAsked && !reloading) {
        reloading = true;
        window.location.reload();
        return;
      }
      if (hadController && btn && !reloading) {
        // Another tab activated a new build.  This page still runs the old
        // code: offer the reload, never force it.
        btn.textContent = 'New build installed – reload';
        btn.hidden = false;
        btn.disabled = false;
        if (badge) { badge.hidden = false; }
      }
      hadController = true;
      refresh();
    });
    sw.addEventListener('message', function (e) {
      var d = e.data || {};
      if (d.type === 'kf-install-failed') {
        lastFailure = 'download failed: ' + d.reason;
        console.warn('offline bundle for build ' + d.build + ' failed to install: ' + d.reason);
        setTimeout(refresh, 0);
      }
    });
    if (typeof sw.startMessages === 'function') { sw.startMessages(); }

    say('Offline: checking…');
    sw.register('./sw.js', { scope: './', updateViaCache: 'none' }).then(function (r) {
      reg = r;
      r.addEventListener('updatefound', function () { track(r.installing); });
      if (r.installing) { track(r.installing); }
      if (r.waiting && sw.controller) { showUpdate(r.waiting); }
      refresh();
      check();
    }).catch(function (e) {
      console.warn('service worker registration failed', e);
      say('Offline: unavailable');
    });

    document.addEventListener('visibilitychange', function () {
      if (document.visibilityState === 'visible') { check(); refresh(); }
    });

    try {
      if (navigator.storage && typeof navigator.storage.persist === 'function') {
        navigator.storage.persist().then(noop, noop);
      }
    } catch (e) { /* ignore */ }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
}());
