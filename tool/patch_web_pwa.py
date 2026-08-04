#!/usr/bin/env python3
"""Normalize Flutter Web for iOS Safari and Home Screen standalone mode."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
WEB = ROOT / "web"
INDEX = WEB / "index.html"
MANIFEST = WEB / "manifest.json"
BUILD_TAG = "stage18a"

viewport = (
    '<meta name="viewport" content="width=device-width, initial-scale=1.0, '
    'minimum-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">'
)

head_block = f"""
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-title" content="Ugur">
  <meta name="apple-mobile-web-app-status-bar-style" content="default">
  <meta name="theme-color" content="#ffffff">
  <style id="ugur-ios-standalone-fix">
    :root {{
      color-scheme: light;
      --ugur-viewport-height: 100vh;
    }}
    @supports (height: 100dvh) {{
      :root {{ --ugur-viewport-height: 100dvh; }}
    }}
    html, body {{
      margin: 0;
      padding: 0;
      width: 100%;
      min-width: 100%;
      height: var(--ugur-viewport-height);
      min-height: var(--ugur-viewport-height);
      overflow: hidden;
      overscroll-behavior: none;
      background: #ffffff;
      -webkit-text-size-adjust: 100%;
      text-size-adjust: 100%;
      touch-action: manipulation;
    }}
    body {{
      position: fixed;
      inset: 0;
    }}
    flutter-view, flt-glass-pane {{
      width: 100% !important;
      height: 100% !important;
      max-width: 100% !important;
    }}
  </style>
  <script id="ugur-cache-reset">
    // Installed iOS web apps can keep an older Flutter shell after Safari has
    // already updated. This prototype always removes legacy workers/caches so
    // browser and Home Screen launch the same build.
    window.addEventListener('load', function () {{
      if ('serviceWorker' in navigator) {{
        navigator.serviceWorker.getRegistrations().then(function (items) {{
          items.forEach(function (registration) {{ registration.unregister(); }});
        }});
      }}
      if ('caches' in window) {{
        caches.keys().then(function (keys) {{
          keys.forEach(function (key) {{ caches.delete(key); }});
        }});
      }}
    }});
  </script>
"""

text = INDEX.read_text(encoding="utf-8")
text = re.sub(
    r'<meta\s+name=["\']viewport["\'][^>]*>',
    viewport,
    text,
    count=1,
    flags=re.I,
)
if viewport not in text:
    text = text.replace("<head>", "<head>\n  " + viewport, 1)
if 'id="ugur-ios-standalone-fix"' not in text:
    text = text.replace("</head>", head_block + "\n</head>", 1)
# Add a build query to the bootstrap script so an installed icon cannot reuse
# an older HTML/bootstrap pair.
text = re.sub(
    r'src=["\']flutter_bootstrap\.js(?:\?[^"\']*)?["\']',
    f'src="flutter_bootstrap.js?v={BUILD_TAG}"',
    text,
    count=1,
)
INDEX.write_text(text, encoding="utf-8")

manifest = json.loads(MANIFEST.read_text(encoding="utf-8")) if MANIFEST.exists() else {}
manifest.update({
    "name": "Ugur",
    "short_name": "Ugur",
    "start_url": f"./?build={BUILD_TAG}",
    "scope": "./",
    "display": "standalone",
    "display_override": ["standalone", "minimal-ui"],
    "orientation": "portrait-primary",
    "background_color": "#ffffff",
    "theme_color": "#ffffff",
    "description": "Гостиницы Туркменистана",
})
MANIFEST.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
