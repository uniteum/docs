---
title: Mimicry (renamed)
nav_exclude: true
sitemap: false
search_exclude: true
---

# This page has moved

The Mimicry factory has been renamed — first to Notable, and now to **[Reflector](/reflector/)** — and Reflector lives in its own top-level section.

- New page: [Reflector](/reflector/)
- New mechanics page: [Peg mechanics](/reflector/mechanics/)

The `mimic(name)` write function is now `issue(name, variant)`, and the `mimicked(...)` read functions are now `issued(name, variant)`. The `make(original, symbol)` write function is now `make(peg, symbol, variant)` — every public Reflector call takes a trailing `variant` (vanity-mining nonce; pass `0` for the default address).
