---
title: ENS
description: >-
  ENS naming structure for Uniteum contracts,
  deployers, and infrastructure.

# Navigation

# Taxonomy

# Metadata
weight: 3
---

# ENS Structure

Uniteum uses ENS for human-readable addressing. All names are under `uniteum.eth`, owned by `0xd441...6401`.

## Hierarchy

```
uniteum.eth
├── {{< val "contracts.genesis.ens" >}}          → {{< val "contracts.genesis.address" >}}
│                               ({{< val "contracts.genesis.name" >}} - genesis)
│
├── {{< val "contracts.uniteum.ens" >}}          → {{< val "contracts.uniteum.address" >}}
│                               ({{< val "contracts.uniteum.name" >}})
│
├── eoa.uniteum.eth          → 0x6056...496e
│   ├── 0.eoa.uniteum.eth    → 0xff96a8c70dcc85a0cc4d690bfc02166a90e71004
│   │                           (main deployer)
│   ├── 1.eoa.uniteum.eth    → 0x215a...7003
│   ├── 2.eoa.uniteum.eth    → 0xc935...8971
│   └── 3.eoa.uniteum.eth    → (reserved)
│
├── deployer.uniteum.eth     → 0x2613...878a
│                               (Safe multisig)
│
├── vault.uniteum.eth        → 0xebca...77d8
│
└── ens.uniteum.eth          → 0x6056...496e
```

## Naming Convention

### Version Names

Format: `{major}-{minor}.uniteum.eth`

- `0-0.uniteum.eth` — Version 0.0 (genesis)
- `{{< val "contracts.uniteum.ens" >}}` — {{< val "contracts.uniteum.name" >}} (current)

### EOA Names

Format: `{index}.eoa.uniteum.eth`

Numbered externally owned accounts for deployment and operations.

### Functional Names

- `deployer.uniteum.eth` — Multisig for deployments
- `vault.uniteum.eth` — Treasury/reserve
- `ens.uniteum.eth` — ENS management

## Resolving Names

Use any ENS-compatible tool:

```javascript
// ethers.js
const address = await provider.resolveName("uniteum.eth");
```

Or check directly on [app.ens.domains](https://app.ens.domains).
