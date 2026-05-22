---
title: Floating Units
description: >-
  Catalog of floating (unbacked) example units used throughout Uniteum documentation,
  with deterministic addresses and deployment instructions.
weight: 2
---

# Floating Units Reference

This page catalogs all floating (unbacked) example units used throughout the Uniteum documentation. These units serve as pedagogical examples and can be deployed on any network for experimentation.

Unlike [anchored units](/uniteum/reference/anchored-units/), floating units have no external backing—their value emerges purely from liquidity and market consensus.

## Key Properties

- **Deterministic Addresses**: All addresses are calculated using CREATE2 and are identical across all networks (mainnet, Sepolia, etc.)
- **Not Yet Deployed**: These addresses are predicted but units may not be deployed yet
- **Anyone Can Deploy**: Call `one().multiply("symbol")` to deploy any unit
- **Educational Purpose**: These are example units for learning and experimentation

## Base Units

Single-symbol units with no operators.

{{% units_table filter="base" %}}

## Reciprocal Units

Units of the form `1/X`.

{{% units_table filter="reciprocal" %}}

## Compound Units

Products, ratios, and powers (`*`, `/`, `^`).

{{% units_table filter="compound" %}}

## How to Deploy

These units are not automatically deployed. To deploy any unit:

### Using Etherscan

1. Go to [the current Uniteum contract on the block explorer](https://{{< escan >}}/address/{{< val "contracts.uniteum.address" >}}#writeContract)
2. Connect your wallet
3. Call `multiply(string expression)` with the symbol (e.g., `"foo"`)
4. The unit will be deployed to its deterministic address
5. View the newly deployed unit at the predicted address

### Using cast (command line)

```bash
# Predict address (read-only, no gas cost)
cast call {{< val "contracts.uniteum.address" >}} \
  "product(string)(address,string)" "foo" \
  --rpc-url https://eth.llamarpc.com

# Deploy (requires wallet and gas)
cast send {{< val "contracts.uniteum.address" >}} \
  "multiply(string)(address)" "foo" \
  --rpc-url https://eth.llamarpc.com \
  --private-key $PRIVATE_KEY
```

### Using ethers.js

```javascript
const uniteum = new ethers.Contract(
  "{{< val "contracts.uniteum.address" >}}",
  uniteumABI,
  signer
);

// Deploy foo
const tx = await uniteum.multiply("foo");
await tx.wait();

// Get address
const [address, canonical] = await uniteum.product("foo");
console.log(`foo deployed to: ${address}`);
```

## See Also

- [Anchored Units](/uniteum/reference/anchored-units/) - Real ERC-20 backed units
- [Creating Units Guide](/uniteum/guides/creating-units/) - How to create your own units
- [Contracts Reference](/uniteum/reference/contracts/) - Contract addresses and interfaces
