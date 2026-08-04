#!/usr/bin/env python3
"""Final no-cache cleanup for the GitHub Pages bundle."""
from __future__ import annotations

import re
import sys
from pathlib import Path

build = Path(sys.argv[1] if len(sys.argv) > 1 else "build/web")
(build / ".nojekyll").write_text("", encoding="utf-8")

# If an older Flutter SDK still emits a worker despite the build flag, remove it.
worker = build / "flutter_service_worker.js"
if worker.exists():
    worker.unlink()

index = build / "index.html"
if index.exists():
    text = index.read_text(encoding="utf-8")
    text = re.sub(
        r'src=["\']flutter_bootstrap\.js(?:\?[^"\']*)?["\']',
        'src="flutter_bootstrap.js?v=stage18a"',
        text,
        count=1,
    )
    index.write_text(text, encoding="utf-8")
