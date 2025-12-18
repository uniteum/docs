---
title: Known Issues
description: Critical bugs and limitations in Uniteum versions
nav_order: 100
last_updated: 2024-12-17
---

# Known Issues

## Current Status — Uniteum 0.3

**Status:** No known issues as of December 2024
**Version:** 0.3
**Networks:** Mainnet and Sepolia

Uniteum 0.3 is the current production version. All previously identified bugs from versions 0.1 and 0.2 have been resolved.

All core functionality is operational:
- ✅ Forge operations with floating units
- ✅ Forge operations with anchored units
- ✅ Forge operations with compound units
- ✅ Creating units via `multiply()` and `product()`
- ✅ Anchored units via `anchored(IERC20)`
- ✅ Migration between versions

If you discover any issues, please [report them](#reporting-issues).

## Reporting Issues

Found a bug or unexpected behavior?

- **GitHub Issues:** [uniteum/docs/issues](https://github.com/uniteum/docs/issues)
- **Twitter:** [@uniteum1](https://twitter.com/uniteum1)
- **Email:** paul@uniteum.one

Include:
- Transaction hash (if applicable)
- Network (Mainnet/Sepolia)
- Contract version
- Expected vs actual behavior
- Steps to reproduce

## Version History

### Uniteum 0.3 (Current)
- **Released:** December 2024
- **Status:** No known issues
- **Fixed:** All bugs from 0.1 and 0.2

### Uniteum 0.2
- **Status:** Superseded by 0.3
- **Fixed:** Critical forge bugs with anchored and compound units from 0.1

### Uniteum 0.1
- **Status:** Deprecated
- **Issues:** Critical forge bugs with anchored units and compound units (resolved in 0.2)

### Uniteum 0.0 (Primordial)
- **Status:** Genesis "1" token (simple ERC-20, no forge features)
- **Purpose:** Initial supply distribution, migration to later versions

## Safety Notice

Uniteum is experimental, unaudited software. Even with no currently known issues, smart contract risk remains.

**Use at your own risk.** See [Safety](/safety/) for full disclaimers.

---

**Last Updated:** {{ page.last_updated }}
