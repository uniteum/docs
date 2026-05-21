---
title: Known Issues
description: Critical bugs and limitations in Uniteum versions
weight: 100
---

# Known Issues

## Current Status — {{< val "contracts.uniteum.name" >}}

**Status:** No known bugs with floating unit operations. Anchored units are incomplete.
**Version:** {{< val "contracts.uniteum.name" >}}
**Networks:** Mainnet and Sepolia

{{< val "contracts.uniteum.name" >}} is the current production version. Previously identified bugs from earlier versions have been resolved. Anchored unit mechanics (deposit, withdrawal, anchored forge) are not yet fully implemented and may not be achievable as currently designed.

Core functionality status:
- ✅ Forge operations with floating units
- ⚠️ Forge operations with anchored units — **incomplete, may not work as intended**
- ⚠️ Forge operations with compound units — **incomplete**: the compound `forge(IUnit V, ...)` path in `Unit.sol:124-129` operates the `(this, reciprocal, ONE)` triad rather than the `(this, V, sqrt(this·V))` triad it documents. Forging across true compound triads is not yet implemented as intended.
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

**Last Updated:** {{< val "contracts.uniteum.name" >}}
