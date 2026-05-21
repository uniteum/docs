---
title: Locale
weight: 13
bookCollapseSection: true
---
# Locale

**Immutable reference contracts at deterministic addresses, with data native to each chain.**

Locale deploys lookup contracts that resolve to chain-specific values. The same address exists on every supported network. Query it on Ethereum mainnet and you get one answer. Query it on Arbitrum and you get another. The address never changes. The data never changes. There is no owner.

No governance.
No upgrade path.
No admin functions.

---

## Why this exists

Cross-chain development has a coordination problem. A contract like USDC lives at a different address on every network. Protocols that need to reference it must maintain off-chain registries, pass addresses as constructor arguments, or hardcode per-chain constants. Each approach introduces trust assumptions or maintenance burden.

Locale eliminates this. A single on-chain lookup — deployed at the same address on every chain — resolves to the correct local value. Contracts, SDKs, and UIs can hardcode one address and resolve everywhere.

Every Locale instance:

- Has a **deterministic address** — known before deployment, identical across chains
- Stores **immutable data** — initialized once and never changed
- Has **no owner** — no admin, no governance, no upgrade mechanism
- Is **permissionless** — anyone can deploy a new lookup through the factory
- Is **chain-aware** — same bytecode everywhere, different contents per network

---

## How it works

Locale uses [EIP-1167 minimal proxy clones](https://eips.ethereum.org/EIPS/eip-1167) deployed via CREATE2. The factory contract holds the implementation logic. Each `make` call deploys a lightweight proxy and initializes it atomically.

### The deterministic lookup pattern

The key insight: the salt is derived from the *entire* set of chain mappings, not just the local chain's value. Every chain receives the same salt, so every chain produces the same address.

The factory exposes a single `make(Entry[] entries, uint256 variant)` entry point. The companion `made(...)` view returns `(bool exists, address home, bytes32 salt)` — useful for previewing a clone's address before deploying it. Both functions accept a `variant` so the same `entries` array can yield distinct clones if you ever need parallel deployments.

The salt and address are computed identically on every chain:

```solidity
// Salt is chain-agnostic — identical on every network for the same args+variant
bytes32 salt = keccak256(encode(entries)) ^ bytes32(variant);

address home = Clones.cloneDeterministic(proto, salt, 0);

// Atomically initialize the clone. zzInit is `onlyProto`, so external
// callers cannot front-run or re-initialize the clone.
IPrototype(home).zzInit(abi.encode(entries), variant);
```

The chain-id branch lives **inside** the clone's `zzInit`, not in the factory. For `AddressLookup` and `StringLookup`, `zzInit` walks the entries and stores only the one matching `block.chainid`. For `ImmutableUintToAddress` and `ImmutableUintToUint`, `zzInit` stores every entry. Either way, `make` is idempotent: calling it again with the same `entries` and `variant` returns the existing address without redeploying.

### Contract types

Locale provides four contract types organized into two behavioral families. Both families share the same deterministic factory pattern (atomic deploy + init, immutable data, identical address across chains); they differ in what `zzInit` stores per clone.

**Single-chainid lookups** — `zzInit` picks the entry matching `block.chainid` and exposes it via `value`:

| Contract | Maps | Exposes | Use case |
|:---------|:-----|:--------|:---------|
| **AddressLookup** | chain id → address | `value` (address) | Cross-chain token addresses, endpoints, bridges |
| **StringLookup** | chain id → string | `value` (string) | Per-chain RPC URLs, names, identifiers |

**Full-map lookups** — `zzInit` stores every entry, exposing the full map via `keyAt[]` and `valueOf(key)`:

| Contract | Maps | Exposes | Use case |
|:---------|:-----|:--------|:---------|
| **ImmutableUintToAddress** | uint → address | `keyAt[]`, `valueOf(uint)` | Multi-key registries (e.g. id → router) |
| **ImmutableUintToUint** | uint → uint | `keyAt[]`, `valueOf(uint)` | Numeric parameters (e.g. id → gas limit) |

---

## Try it on-chain

You can interact with the AddressLookup factory using standard tools like
[Etherscan](https://etherscan.io) or
[Blockscout](https://eth.blockscout.com).

### Factory contract

[`{{< val "locale.address" >}}`](https://etherscan.io/address/{{< val "locale.address" >}}#code)

### Functions

| Action | What it does |
|:-------|:-------------|
| [make(entries, variant)](https://etherscan.io/address/{{< val "locale.address" >}}#writeContract#F{{< val "locale" "write" "make((uint256,address)[],uint256)" "f" >}}) | Deploy a new lookup with chain-specific entries |
| [made(entries, variant)](https://etherscan.io/address/{{< val "locale.address" >}}#readContract#F{{< val "locale" "read" "made((uint256,address)[],uint256)" "f" >}}) | Check if a lookup exists and preview its address |
| [value()](https://etherscan.io/address/{{< val "locale.address" >}}#readContract#F{{< val "locale" "read" "value()" "f" >}}) | Read the chain-specific address for a deployed lookup |

### Live example: USDC lookup

<!-- TODO BLK-4: this hardcoded address is a clone of the *legacy* AddressLookup
     prototype; the canonical USDC clone of the current prototype is not yet
     deployed. Replace with a `{{< val >}}` reference once the maintainer
     finalizes the prototype choice and the new clone is deployed. -->
The USDC AddressLookup is deployed at [`0xfE52eC4D4Ac10b5b0718614AA0077F2920f592e8`](https://etherscan.io/address/0xfE52eC4D4Ac10b5b0718614AA0077F2920f592e8#readContract). Query `value()` on any supported chain and it returns that chain's USDC address.

---

## Design

### Why deterministic addresses?

Protocols that integrate Locale lookups can hardcode a single address at compile time. No constructor arguments, no registries, no deployment coordination. The address works on every chain, now and in the future.

This also enables counterfactual reasoning — you can compute the address of a lookup before it is deployed and build against it with confidence.

### Why immutable?

Immutability removes an entire class of risk. There is no owner who can change the resolved address. There is no governance vote that can redirect a lookup. What you deploy is what you get, forever.

### Why chain-aware?

The alternative — deploying different contracts with different addresses per chain — defeats the purpose. Locale's design ensures identical bytecode and identical addresses while allowing the *contents* to vary. The variation is locked in at deploy time via `block.chainid`, not via admin calls.

### Prerequisites

- All chain-specific values must be known at deployment time. Adding a new chain requires deploying a new lookup with an expanded key set.
- Requires [Nick's CREATE2 factory](https://github.com/Arachnid/deterministic-deployment-proxy) on the target chain.

---

## Resources

- [GitHub Repository](https://github.com/uniteum/locale)
- [Contract Source](https://etherscan.io/address/{{< val "locale.address" >}}#code)
- [Deterministic Lookup](/locale/deterministic-lookup) — the deployment pattern in depth
