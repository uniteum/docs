---
title: Known Issues
description: Critical bugs and limitations in Uniteum versions
nav_order: 100
parent: Uniteum
last_updated: 2024-12-17
---

# Known Issues

## Current Status — {{ site.data.contracts.uniteum.name }}

**Status:** No known bugs with floating unit operations. Anchored units are incomplete.
**Version:** {{ site.data.contracts.uniteum.name }}
**Networks:** Mainnet and Sepolia

{{ site.data.contracts.uniteum.name }} is the current production version. Previously identified bugs from earlier versions have been resolved. Anchored unit mechanics (deposit, withdrawal, anchored forge) are not yet fully implemented and may not be achievable as currently designed.

Core functionality status:
- ✅ Forge operations with floating units
- ⚠️ Forge operations with anchored units — **incomplete, may not work as intended**
- ✅ Forge operations with compound units
- ✅ Creating units via `multiply()` and `product()`
- ⚠️ Anchored units via `anchored(IERC20)` — **incomplete**
- ✅ Migration between versions

If you discover any issues, please [report them](#reporting-issues).

## Reporting Issues

Found a bug or unexpected behavior?

- **GitHub Issues:** [uniteum/uniteum/issues](https://github.com/uniteum/uniteum/issues)
- **Twitter:** [@uniteum1](https://twitter.com/uniteum1)
- **Email:** team@uniteum.com

Include:
- Transaction hash (if applicable)
- Network (Mainnet/Sepolia)
- Contract version
- Expected vs actual behavior
- Steps to reproduce

## Safety Notice

Uniteum is experimental, unaudited software. Even with no currently known issues, smart contract risk remains.

**Use at your own risk.** See [Safety](/uniteum/safety/) for full disclaimers.

---

**Last Updated:** {{ page.last_updated }}
