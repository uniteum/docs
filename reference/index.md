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

{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
{% assign genesis_uniteum = site.data.contracts.uniteum.v0_0 -%}
{% assign current_kiosk = site.data.contracts.kiosk[site.data.contracts.current.kiosk] -%}

| Contract | Address |
|----------|---------|
| {{ current_uniteum.name }} | {% include etherscan.html address=current_uniteum.mainnet section="code" text=current_uniteum.mainnet %} |
| {{ genesis_uniteum.name }} | {% include etherscan.html address=genesis_uniteum.mainnet section="code" text=genesis_uniteum.mainnet %} |
| {{ current_kiosk.name }} | {% include etherscan.html address=current_kiosk.mainnet section="code" text=current_kiosk.mainnet %} |

### Networks

Uniteum is deployed identically on:
- Ethereum Mainnet
- Sepolia Testnet

Same addresses on both networks (Nick's deterministic deployer).

## Source Code

GitHub: [github.com/uniteum](https://github.com/uniteum)
