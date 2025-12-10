---
title: ENS
description: >-
  ENS naming structure for Uniteum contracts,
  deployers, and infrastructure.

# Navigation
nav_order: 3
parent: Reference
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
├── 0-0.uniteum.eth          → 0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4
│   │                           (Uniteum 0.0 "1" - genesis)
│   └── buy.0-0.uniteum.eth  → 0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9
│                               (Discount Kiosk)
│
├── 0-1.uniteum.eth          → 0x9df9b0501e8f6c05623b5b519f9f18b598d9b253
│                               (Uniteum 0.1 "1")
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
