---
title: Contracts
description: >-
  Deployed contract addresses, verification links,
  and deployment details for Uniteum.

# Navigation
nav_order: 1
parent: Reference
grand_parent: Uniteum
has_children: false

# Taxonomy
categories:
  - development

# Metadata
last_updated: 2024-12-17
version: "0.3"
status: draft
---

# Contracts

All Uniteum contracts are deployed using Nick's deterministic deployer, resulting in identical addresses across networks.

## Core Contracts

### {{ site.data.contracts.uniteum.name }}

{{ site.data.contracts.uniteum.description }}

{% include contract_table.html contract=site.data.contracts.uniteum %}

### {{ site.data.contracts.genesis.name }}

{{ site.data.contracts.genesis.description }}

{% include contract_table.html contract=site.data.contracts.genesis %}

## Deployment

### Deployer

Nick's deterministic deployment method ensures identical addresses across any EVM chain.

**Deployer EOA:** {% include contract.html address=site.data.contracts.deployer.address text="0.eoa.uniteum.eth" %}

### Architecture

- **Minimal proxy clones:** EIP-1167 for gas-efficient unit deployment
- **CREATE2:** Deterministic address derivation from symbol hash
- **Solidity:** 0.8.30
- **Framework:** Foundry

## Verification

All contracts are verified on Etherscan. Source code available at [github.com/uniteum](https://github.com/uniteum).

## Audit Status

**Not audited.** See [Safety](/uniteum/safety/).
