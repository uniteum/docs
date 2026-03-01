---
title: ENS
description: >-
  ENS naming structure for Uniteum contracts,
  deployers, and infrastructure.

# Navigation
nav_order: 3
parent: Reference
grand_parent: Uniteum
has_children: false

# Taxonomy
categories:
  - development

# Metadata
last_updated: 2024-12-09
version: "0.1"
status: draft
---

# ENS Structure

Uniteum uses ENS for human-readable addressing. All names are under `uniteum.eth`, owned by `0xd441...6401`.

## Hierarchy

```
uniteum.eth
├── {{ site.data.contracts.genesis.ens }}          → {{ site.data.contracts.genesis.address }}
│   │                           ({{ site.data.contracts.genesis.name }} - genesis)
│   └── buy.0-0.uniteum.eth  → 0x64dB548312da6D88fB4016157e521d9f2f65AFFc
│                               (Buy Uniteum 0.0 '1')
│
├── {{ site.data.contracts.uniteum.ens }}          → {{ site.data.contracts.uniteum.address }}
│   │                           ({{ site.data.contracts.uniteum.name }})
│   └── {{ site.data.contracts.kiosk.ens }}  → {{ site.data.contracts.kiosk.address }}
│                               ({{ site.data.contracts.kiosk.name }})
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
- `0-1.uniteum.eth` — Version 0.1 (current)

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
const address = await provider.resolveName("0-1.uniteum.eth");
```

Or check directly on [app.ens.domains](https://app.ens.domains).
