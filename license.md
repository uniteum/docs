---
title: Uniteum License
description: Full text of the Uniteum License governing the smart contract software.

# Navigation
nav_order: 101
has_children: false

# Metadata
last_updated: 2024-12-11
version: "0.1"
---

# Uniteum License

The Uniteum protocol smart contracts are licensed under the **Uniteum License** — a permissive open-source license with specific provisions to protect the protocol's integrity.

{: .important }
> **TL;DR:** You can use, fork, and modify the code freely. You must give attribution. You cannot create competing protocols using the "Uniteum" or "1" names unless they're fully interoperable with the canonical deployment.

## Full License Text

```
Uniteum License
===============

Copyright (c) 2025 Uniteum Project

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and any associated documentation files (the "Software"), to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, subject to the following conditions:

1. Attribution
   All copies or substantial portions of the Software must include a notice
   stating: "Includes components licensed under the Uniteum License" and, if
   available, a link to the official Uniteum Project.

2. Anti-Dilution
   No person may create, deploy, or distribute any software, smart contract,
   token, cryptocurrency, or unit system that uses the names "Uniteum", "1",
   "one", or any confusingly similar designation to identify a base unit,
   token, protocol, or system, unless it is fully interoperable with the
   official Uniteum system and recognizes the canonical Uniteum base-unit
   contract. Any non-interoperable or competing system using such names is
   prohibited.

3. No Trademark Rights
   This license does not grant any rights to use "Uniteum" or related marks
   for branding or marketing purposes beyond the attribution required above.

4. Disclaimer
   The Software is provided "as is", without warranty of any kind, express or
   implied, including but not limited to merchantability, fitness for a
   particular purpose, and noninfringement. In no event shall the authors or
   copyright holders be liable for any claim, damages, or other liability,
   whether in an action of contract, tort, or otherwise, arising from or in
   connection with the Software or the use or dealings in the Software.

END OF TERMS
```

## What This Means

### ✅ You CAN:

- **Use the code** for any purpose (commercial or non-commercial)
- **Fork and modify** the smart contracts to create your own protocols
- **Deploy your own instances** on any network
- **Integrate Uniteum** into your applications
- **Study and learn** from the implementation
- **Sell products** built on or using the code

### ⚠️ You MUST:

- **Provide attribution** in your code/documentation
- Include the notice: "Includes components licensed under the Uniteum License"
- Link to the official Uniteum project when possible

### ❌ You CANNOT:

- **Create competing protocols** using "Uniteum", "1", or "one" names unless:
  - Your system is fully interoperable with canonical Uniteum
  - It recognizes the official "1" token contract
- **Use "Uniteum" for branding/marketing** beyond required attribution
- **Claim endorsement** by the Uniteum Project

## Why the Anti-Dilution Clause?

The "1" token is the **base unit** of the entire Uniteum system. Its integrity depends on having a single, canonical deployment that all units reference. The anti-dilution clause prevents:

- **Namespace pollution:** Multiple incompatible "1" tokens would destroy the algebraic properties
- **User confusion:** Prevents scam projects claiming to be "Uniteum"
- **Network effects:** Preserves liquidity concentration in one protocol

If you want to build your own algebraic liquidity system with different properties, you're **completely free to do so** — just use a different name.

## Interoperability Exception

You **can** use the "Uniteum" and "1" names if your system:

1. **Recognizes the canonical contracts** (see [deployments](/contracts/))
2. **Maintains full interoperability** (your units can forge with official units)
3. **Doesn't fragment liquidity** into competing bases

Examples of allowed use:
- Alternative frontends for Uniteum
- Tools/analytics/explorers for the protocol
- Bridges/integrations that use official contracts
- Educational forks clearly marked as testnet/learning projects

## Source Code

Canonical source: [github.com/uniteum/uniteum](https://github.com/uniteum/uniteum)

Deployed contracts are **immutable** and **unaudited**. See [Safety](/safety/) for risk disclosures.

## Questions?

- **General questions:** reinholdtsen.eth
- **Security issues:** [GitHub security policy](https://github.com/uniteum/uniteum/security)
- **License interpretation:** This is novel legal territory. When in doubt, ask.

---

**Canonical License:** [LICENSE.Uniteum](https://github.com/uniteum/uniteum/blob/main/LICENSE.Uniteum) in the source repository

**Last updated:** December 2024
