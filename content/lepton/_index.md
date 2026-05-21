---
title: Lepton
weight: 11
bookCollapseSection: true
---
# Lepton

**A minimalist token factory. One call makes a fixed-supply ERC-20.**

Named after the ancient Greek lepton (λεπτόν) — the smallest denomination coin — and the fundamental particles in physics, which are elementary and indivisible.

Lepton deploys ERC-20 tokens with deterministic addresses. You pick a name, symbol, and supply. One transaction creates the token and mints the entire supply to you. That's it — no inflation, no minting function, no owner.

No launch.
No governance.
No surprises.

---

## Why this exists

Creating a simple fixed-supply ERC-20 should not require writing a contract. Lepton reduces it to a single function call on an existing factory.

Every Lepton token:

- Is a **standard ERC-20** — compatible with any wallet, DEX, or protocol
- Has a **fixed supply** — all tokens minted at creation, never more
- Has a **deterministic address** — the same parameters always produce the same address
- Is **permissionless** — anyone can deploy a new token
- Has **no owner** — once created, no one controls it

---

## How it works

Lepton uses [EIP-1167 minimal proxy clones](https://eips.ethereum.org/EIPS/eip-1167) deployed via CREATE2 for deterministic addressing.

The factory contract holds the implementation logic. Each `make` call deploys a lightweight proxy that delegates to the factory, then initializes it with the caller's name, symbol, and supply.

### Make a token

Call `make(name, symbol, decimals, supply, variant)` on the Lepton factory. The entire supply is minted to `msg.sender`. Pass `variant = 0` unless you need to deploy a second token with otherwise-identical parameters.

```
make("MyToken", "MTK", 18, 1000000000000000000000000, 0)
```

### Check if a token exists

Call `made(maker, name, symbol, decimals, supply, variant)` to check whether a token with those exact parameters has already been deployed and to preview its deterministic address.

### Idempotent deployment

Calling `make` with the same parameters from the same address returns the existing token — it does not deploy a duplicate. The deployment salt is `keccak256(abi.encode(maker, name, symbol, decimals, supply)) XOR bytes32(variant)`, so different callers, different parameters, or a different `variant` always produce different tokens. Pass `variant = 0` for the canonical deployment; bump `variant` to deploy additional tokens with otherwise-identical parameters.

---

## Try it on-chain

You can interact with Lepton using standard tools like
{{< explorer >}} or
[Blockscout](https://eth.blockscout.com).

### Factory contract

[`0x14ae57aed6ac1cd48fa811ed885ab4a4c5e28c42`]({{< escan >}}/address/0x14ae57aed6ac1cd48fa811ed885ab4a4c5e28c42#code)

### Functions

| Action | What it does |
|:-------|:-------------|
| [make(name, symbol, decimals, supply, variant)]({{< escan >}}/address/0x14ae57aed6ac1cd48fa811ed885ab4a4c5e28c42#writeContract#F{{< val "lepton" "write" "make(name, symbol, decimals, supply, variant)" "f" >}}) | Deploy a new ERC-20 token |
| [made(maker, name, symbol, decimals, supply, variant)]({{< escan >}}/address/0x14ae57aed6ac1cd48fa811ed885ab4a4c5e28c42#readContract#F{{< val "lepton" "read" "made(maker, name, symbol, decimals, supply, variant)" "f" >}}) | Check if a token exists and preview its address |

Each deployed token is a standard ERC-20 with `name()`, `symbol()`, `decimals()`, `totalSupply()`, `balanceOf()`, `transfer()`, `approve()`, and `transferFrom()`.

---

## Design

### Why minimal proxies?

EIP-1167 clones are the smallest possible deployed bytecode — just a forwarding stub. This keeps gas costs low and avoids code duplication across hundreds or thousands of tokens.

### Why deterministic addresses?

CREATE2 deployment means the token address is known before deployment. This enables:

- **Idempotent creation** — calling `make` twice is safe; it returns the same address
- **Address prediction** — `made` returns the address without deploying
- **Unique tokens** — the same maker with the same parameters always gets the same token

### Why fixed supply?

Fixed supply is the simplest useful token model. No mint function means no inflation risk, no governance over monetary policy, and no trust required. The entire supply exists from block one.

---

## Resources

- [GitHub Repository](https://github.com/uniteum/lepton)
- [Contract Source]({{< escan >}}/address/0x14ae57aed6ac1cd48fa811ed885ab4a4c5e28c42#code)
