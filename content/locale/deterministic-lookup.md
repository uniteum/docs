---
title: Deterministic Lookup
weight: 1
---

# Deterministic Lookup

**A deployment pattern that gives contracts a global address with chain-local values.**

---

## The problem

Deploying the same contract across multiple blockchains is deceptively difficult. Contract addresses are derived from deployment context, and even with deterministic methods like `CREATE2`, differing constructor arguments yield divergent addresses. Contracts intended to represent the same logical component often end up scattered across networks at inconsistent addresses.

For developers, this creates integration friction. For users, it introduces risk — selecting the wrong address on the wrong chain can lead to lost funds or broken interoperability.

Off-chain registries are often used to bridge the gap, but they add trust assumptions, require constant maintenance, and are error-prone.

Counterfactual systems expose the weakness most clearly. They rely on the ability to reason about a contract's address *before* it is deployed. If addresses differ across chains, the counterfactual model collapses.

---

## The solution

Deterministic Lookup solves this coordination problem by separating *identity* from *content*.

A contract is deployed at an identical, predetermined address on every chain. Its contents are initialized with chain-specific data. This is achieved by ensuring the deployed bytecode is identical across chains and deferring differences to immutable context — branching on `block.chainid` during initialization.

From the outside, the address is globally invariant. From the inside, the values it exposes are always correct for the local chain.

---

## How it works

### Salt derivation

The salt for CREATE2 deployment is derived from the entire array of chain mappings, XORed with a caller-supplied `variant`:

```
salt = keccak256(encode(entries)) ^ bytes32(variant)
```

Because `entries` is the same array on every chain, the salt is the same. Because the factory bytecode is also the same (deployed via Nick's CREATE2 factory), the resulting clone address is the same.

The `variant` parameter lets the same `entries` array yield distinct clones — set it to `0` for the canonical lookup, or to any other value to mint a parallel clone of the same map.

### Chain selection

The factory deploys the clone first, then atomically calls `zzInit(args, variant)` on it. The chain-id branch lives **inside** `zzInit` on the clone — the factory itself does not inspect `block.chainid`. For `AddressLookup` and `StringLookup`, `zzInit` decodes the entries and stores only the entry matching the local chain id:

```solidity
function zzInit(bytes calldata args, uint256) external override onlyProto {
    Entry[] memory entries = abi.decode(args, (Entry[]));
    for (uint256 i; i < entries.length; ++i) {
        if (entries[i].key == block.chainid) {
            value = entries[i].value;
            break;
        }
    }
}
```

For `ImmutableUintToAddress` and `ImmutableUintToUint`, `zzInit` instead stores **every** entry, exposing the full map via `keyAt[]` and `valueOf(key)`. Both families share the same deterministic deployment pattern; only the per-clone storage policy differs.

### Atomic deployment

Deploy and init happen in a single `make` call on the prototype. The `zzInit` function is `onlyProto` — it reverts unless `msg.sender` is the prototype itself, so external initialization is impossible. If `make` is called again with the same `entries` and `variant`, it returns the existing address without redeploying.

---

## Benefits

- **Global consistency** — one canonical address across all chains
- **Local correctness** — each instance exposes the right value for its own chain
- **Counterfactual safety** — systems can integrate before deployment with confidence in the address
- **Composability** — other protocols can use the same address as a universal reference
- **Trustlessness** — no reliance on off-chain registries or coordinators

---

## Trade-offs

- **Upfront coordination** — all chain-specific values must be known at deployment; adding new chains requires a new lookup
- **Immutability** — ties identity to immutable bytecode, making it incompatible with upgradeable patterns
- **Fixed scope** — efficient in practice, but constrains dynamic configurability

These trade-offs are intentional. Locale prioritizes permanence and trustlessness over flexibility.
