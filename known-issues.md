---
title: Known Issues
description: Critical bugs and limitations in Uniteum versions
nav_order: 100
last_updated: 2024-12-13
---

# Known Issues

## Uniteum 0.1 — Critical Forge Bugs (Mainnet)

**Status:** Identified December 2024
**Affected Network:** Mainnet only
**Severity:** Critical — Do not use on Mainnet
**Fix Timeline:** Uniteum 0.2 release

### Bug #1: Anchored Units Forge Failure

**Issue:** Forge operations involving anchored units (tokens backed by external ERC-20s like [$WETH](/tokens/weth/), [$USDC](/tokens/usdc/), etc.) do not work correctly.

**Impact:**
- Cannot reliably forge with anchored units or their reciprocals
- Cannot create or manipulate positions involving real-world tokens
- Core use cases (hedging, wrapped token derivatives) are broken

**Affected Operations:**
- `forge()` with any anchored unit (e.g., `$0xC02a...` format)
- Creating reciprocals of anchored units
- Compound units containing anchored components

**Workaround:** None. Avoid anchored units on Mainnet entirely until 0.2.

### Bug #2: Compound Units Forge Error

**Issue:** Forge operations for compound units (algebraic compositions like `foo*bar`, `$WETH/USD`, `meter^2`) have implementation errors.

**Impact:**
- Cannot reliably create or manipulate compound unit positions
- Arbitrage relationships between compound units may not hold
- Multi-dimensional derivatives are unreliable

**Affected Operations:**
- `forge()` with compound units created via `multiply()` or `product()`
- Triads involving products like (A, B, A*B)
- Any unit with `*`, `/`, or `^` in its expression

**Workaround:** None. Avoid compound units on Mainnet until 0.2.

## Safe to Use

### ✅ Uniteum 0.0 "1" (Primordial) — Mainnet

**Contract:** [`0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4`](https://etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code)
**Status:** No known issues

The genesis "1" token is a simple ERC-20 with no Uniteum forge features. It is safe to:
- Buy from [Discount Kiosk](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#writeContract)
- Hold and transfer
- Migrate to/from Uniteum 0.1 (though 0.1 forge should be avoided)

### ✅ Uniteum 0.1 — Sepolia Testnet

**Contract:** [`0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`](https://sepolia.etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#code)
**Status:** Same bugs as Mainnet, but safe for testing

Sepolia deployment has the same bugs but carries no real-world value risk. Safe to:
- Experiment with the mechanism
- Test forge operations (expect failures with anchored/compound units)
- Learn the system before 0.2 launches
- Report additional issues

## What Still Works on Uniteum 0.1 Mainnet

### Limited Operations Only

If you have already acquired Uniteum 0.1 "1" tokens on Mainnet (via migration from 0.0), these operations are safe:

- ✅ **Hold and transfer** "1" tokens
- ✅ **Migrate back to 0.0** via `unmigrate()` if desired
- ✅ **Create symbolic base units** via `one().multiply("symbol")` (but don't forge with them)
- ⚠️ **View functions** work (checking invariants, addresses, etc.)

### DO NOT Use on Mainnet

- ❌ Any `forge()` operation with anchored units
- ❌ Any `forge()` operation with compound units
- ❌ Creating anchored units via `anchored(IERC20)`
- ❌ Creating compound units via `product()` or chained `multiply()`
- ❌ Forging with symbolic base unit reciprocals (untested, not recommended)

## Migration Path

### Recommended Actions

1. **If you have 0.0 "1" tokens:**
   - Keep them in 0.0 (safe, simple ERC-20)
   - DO NOT migrate to 0.1 on Mainnet yet
   - Wait for 0.2 announcement

2. **If you already migrated to 0.1:**
   - Consider calling `unmigrate()` to revert to 0.0
   - Or simply hold and wait for 0.2
   - Avoid all forge operations

3. **If you want to experiment:**
   - Use Sepolia testnet
   - Get test "1" tokens from [Sepolia Kiosk](https://sepolia.etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#writeContract)
   - Test forge behaviors and report findings

### Uniteum 0.2 Plans

A fix is in development. Uniteum 0.2 will:
- ✅ Fix anchored unit forge operations
- ✅ Fix compound unit forge operations
- ✅ Maintain full compatibility with "1" token migration
- ✅ Deploy to same deterministic addresses (TBD)

**Timeline:** To be announced. Follow [@uniteum1](https://twitter.com/uniteum1) for updates.

## Reporting Issues

Found another bug or unexpected behavior?

- **GitHub Issues:** [uniteum/docs/issues](https://github.com/uniteum/docs/issues)
- **Twitter:** [@uniteum1](https://twitter.com/uniteum1)
- **Email:** paul@uniteum.one

Include:
- Transaction hash (if applicable)
- Network (Mainnet/Sepolia)
- Contract version (0.0, 0.1)
- Expected vs actual behavior

## Historical Context

This is experimental, unaudited software. These bugs are part of the discovery process. Version 0.1 was deployed to explore the mechanism design in a live environment. The bugs identified will inform 0.2 and strengthen the protocol.

**Uniteum is a research experiment.** Use at your own risk. See [Safety](/safety/) for full disclaimers.

---

**Last Updated:** {{ page.last_updated }}
**Next Review:** Upon 0.2 release announcement
