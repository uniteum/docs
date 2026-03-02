---
title: Reference
description: >-
  Technical reference for Uniteum: contract addresses,
  function signatures, and ENS structure.

# Navigation
nav_order: 6
parent: Uniteum
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

1. **[Contracts](/uniteum/reference/contracts/)** — Addresses, deployment info, verification
2. **[Functions](/uniteum/reference/functions/)** — Contract function reference
3. **[ENS](/uniteum/reference/ens/)** — ENS naming structure
4. **[Floating Units](/uniteum/reference/floating-units/)** — Catalog of example units with addresses

## Quick Reference

### Key Addresses

| Contract | Address |
|----------|---------|
| {{ site.data.contracts.uniteum.name }} | {% include etherscan.html address=site.data.contracts.uniteum.address section="code" text=site.data.contracts.uniteum.address %} |
| {{ site.data.contracts.genesis.name }} | {% include etherscan.html address=site.data.contracts.genesis.address section="code" text=site.data.contracts.genesis.address %} |

### Networks

Uniteum is deployed identically on:
- Ethereum Mainnet
- Sepolia Testnet

Same addresses on both networks (Nick's deterministic deployer).

## Source Code

GitHub: [github.com/uniteum](https://github.com/uniteum)
