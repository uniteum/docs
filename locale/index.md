---
layout: default
title: Locale
nav_order: 13
has_children: true
permalink: /locale/
---

{% assign fn = site.data.locale %}

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

At deploy time, the factory reads `block.chainid` and picks the correct value for the local chain:

```solidity
function make(KeyValue[] memory keyValues) public returns (address home) {
    // Salt is chain-agnostic — identical on every network
    bytes32 salt = keccak256(abi.encode(keyValues));

    Clones.cloneDeterministic(address(this), salt, 0);

    // Pick the value for THIS chain
    for (uint256 i; i < keyValues.length; ++i) {
        if (keyValues[i].key == block.chainid) {
            AddressLookup(home).zzInit(keyValues[i].value);
            break;
        }
    }
}
```

Deploy + init is atomic. `zzInit` can only be called by the factory. Calling `make` twice with the same parameters returns the existing address — it does not redeploy.

### Contract types

Locale provides three contract types, each serving a different mapping shape:

| Contract | Maps | Use case |
|:---------|:-----|:---------|
| **AddressLookup** | one address per chain | Cross-chain token addresses, endpoints, bridges |
| **ImmutableUintToAddress** | uint → address per instance | Multi-key registries (e.g. chain ID → router) |
| **ImmutableUintToUint** | uint → uint per instance | Numeric parameters (e.g. chain ID → gas limit) |

All three follow the same pattern: deterministic factory, atomic init, immutable data.

---

## Try it on-chain

You can interact with the AddressLookup factory using standard tools like
[Etherscan](https://etherscan.io){:target="_blank"} or
[Blockscout](https://eth.blockscout.com){:target="_blank"}.

### Factory contract

[`{{ fn.address }}`](https://etherscan.io/address/{{ fn.address }}#code){:target="_blank"}

### Functions

| Action | What it does |
|:-------|:-------------|
| [make(keyValues)](https://etherscan.io/address/{{ fn.address }}#writeContract#F{{ fn.write["make(keyValues)"].f }}){:target="_blank"} | Deploy a new lookup with chain-specific values |
| [made(keyValues)](https://etherscan.io/address/{{ fn.address }}#readContract#F{{ fn.read["made(keyValues)"].f }}){:target="_blank"} | Check if a lookup exists and preview its address |
| [value()](https://etherscan.io/address/{{ fn.address }}#readContract#F{{ fn.read["value()"].f }}){:target="_blank"} | Read the chain-specific address for a deployed lookup |

### Live example: USDC lookup

The USDC AddressLookup is deployed at [`0xfE52eC4D4Ac10b5b0718614AA0077F2920f592e8`](https://etherscan.io/address/0xfE52eC4D4Ac10b5b0718614AA0077F2920f592e8#readContract){:target="_blank"}. Query `value()` on any supported chain and it returns that chain's USDC address.

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
- [Contract Source](https://etherscan.io/address/{{ fn.address }}#code){:target="_blank"}
- [Deterministic Lookup]({{ site.baseurl }}/locale/deterministic-lookup) — the deployment pattern in depth
