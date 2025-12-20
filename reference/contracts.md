---
title: Contracts
description: >-
  Deployed contract addresses, verification links,
  and deployment details for Uniteum.

# Navigation
nav_order: 1
parent: Reference
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

{%- assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] %}
{%- assign genesis_uniteum = site.data.contracts.uniteum.v0_0 %}

### {{ current_uniteum.name }}

{{ current_uniteum.description }}

{% include contract_table.html contract=current_uniteum %}

### {{ genesis_uniteum.name }}

{{ genesis_uniteum.description }}

{% include contract_table.html contract=genesis_uniteum %}

## Kiosk Contracts

{%- assign current_kiosk = site.data.contracts.kiosk[site.data.contracts.current.kiosk] %}
{%- assign genesis_kiosk = site.data.contracts.kiosk.v0_0 %}

### {{ current_kiosk.name }}

{{ current_kiosk.description }}

{% include contract_table.html contract=current_kiosk %}

### {{ genesis_kiosk.name }}

{{ genesis_kiosk.description }}

{% include contract_table.html contract=genesis_kiosk %}

## Deployment

### Deployer

Nick's deterministic deployment method ensures identical addresses across any EVM chain.

**Deployer EOA:** {% include contract.html address=site.data.contracts.deployer.eoa.mainnet text="0.eoa.uniteum.eth" %}

### Architecture

- **Minimal proxy clones:** EIP-1167 for gas-efficient unit deployment
- **CREATE2:** Deterministic address derivation from symbol hash
- **Solidity:** 0.8.30
- **Framework:** Foundry

## Verification

All contracts are verified on Etherscan. Source code available at [github.com/uniteum](https://github.com/uniteum).

## Audit Status

**Not audited.** See [Safety](/safety/).
