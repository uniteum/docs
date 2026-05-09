---
title: Contracts
description: >-
  Deployed contract addresses, verification links,
  and deployment details for Uniteum.

# Navigation

# Taxonomy

# Metadata
weight: 1
---

# Contracts

All Uniteum contracts are deployed using Nick's deterministic deployer, resulting in identical addresses across networks.

## Core Contracts

### {{< val "contracts.uniteum.name" >}}

{{< val "contracts.uniteum.description" >}}

{{% contract_table key="uniteum" %}}

### {{< val "contracts.genesis.name" >}}

{{< val "contracts.genesis.description" >}}

{{% contract_table key="genesis" %}}

## Deployment

### Deployer

Nick's deterministic deployment method ensures identical addresses across any EVM chain.

**Deployer EOA:** {{< contract address="0xff96a8c70dcc85a0cc4d690bfc02166a90e71004" text="0.eoa.uniteum.eth" >}}

### Architecture

- **Minimal proxy clones:** EIP-1167 for gas-efficient unit deployment
- **CREATE2:** Deterministic address derivation from symbol hash
- **Solidity:** 0.8.30
- **Framework:** Foundry

## Verification

All contracts are verified on Etherscan. Source code available at [github.com/uniteum](https://github.com/uniteum).

## Audit Status

**Not audited.** See [Safety](/uniteum/safety/).
