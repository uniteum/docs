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

The salt for CREATE2 deployment is derived from the entire array of chain mappings:

```
salt = keccak256(abi.encode(keyValues))
```

Because `keyValues` is the same array on every chain, the salt is the same. Because the factory bytecode is the same (deployed via Nick's CREATE2 factory), the resulting clone address is the same.

### Chain selection

During initialization, the factory iterates over the key-value pairs and selects the entry matching `block.chainid`:

```solidity
for (uint256 i; i < keyValues.length; ++i) {
    if (keyValues[i].key == block.chainid) {
        AddressLookup(home).zzInit(keyValues[i].value);
        break;
    }
}
```

### Atomic deployment

Deploy and init happen in a single `make` call. The `zzInit` function can only be called by the factory (`PROTO`), preventing external initialization. If `make` is called again with the same parameters, it returns the existing address without redeploying.

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
