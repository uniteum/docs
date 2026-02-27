---
title: Reference
description: >-
  Technical reference for Uniteum: contract addresses,
  function signatures, and ENS structure.

# Navigation
nav_order: 6
has_children: true

# Taxonomy
categories:
  - development

# Metadata
last_updated: 2024-12-09
status: draft
---

# Reference

Technical reference documentation for developers and advanced users.

## Contents

1. **[Contracts](/reference/contracts/)** — Addresses, deployment info, verification
2. **[Functions](/reference/functions/)** — Contract function reference
3. **[ENS](/reference/ens/)** — ENS naming structure
4. **[Example Units](/reference/example-units/)** — Catalog of example units with addresses

## Quick Reference

### Key Addresses

| Contract | Address |
|----------|---------|
| {{ site.data.contracts.uniteum.name }} | {% include etherscan.html address=site.data.contracts.uniteum.address section="code" text=site.data.contracts.uniteum.address %} |
| {{ site.data.contracts.genesis.name }} | {% include etherscan.html address=site.data.contracts.genesis.address section="code" text=site.data.contracts.genesis.address %} |
| {{ site.data.contracts.kiosk.name }} | {% include etherscan.html address=site.data.contracts.kiosk.address section="code" text=site.data.contracts.kiosk.address %} |

### Networks

Uniteum is deployed identically on:
- Ethereum Mainnet
- Sepolia Testnet

Same addresses on both networks (Nick's deterministic deployer).

## Source Code

GitHub: [github.com/uniteum](https://github.com/uniteum)
