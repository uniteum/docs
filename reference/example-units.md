---
layout: default
title: Example Units Reference
nav_order: 5
parent: Reference
---

# Example Units Reference

This page catalogs all symbolic example units used throughout the Uniteum documentation. These units serve as pedagogical examples and can be deployed on any network for experimentation.

## Key Properties

- **Deterministic Addresses**: All addresses are calculated using CREATE2 and are identical across all networks (mainnet, Sepolia, etc.)
- **Not Yet Deployed**: These addresses are predicted but units may not be deployed yet
- **Anyone Can Deploy**: Call `one().multiply("symbol")` to deploy any unit
- **Educational Purpose**: These are example units for learning and experimentation

## Quick Reference

| Unit Type | Count | Example |
|-----------|-------|---------|
| Base Units | 14 | [`foo`](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430) |
| Reciprocals | 6 | [`1/foo`](https://etherscan.io/token/0xECEb7691f8c5A9D4d8bA2E97E0CfE0eD5b601C8b) |
| Compounds | 11 | [`meter/second`](https://etherscan.io/token/0xCbdc3D8ca6255CbbD1a49F19AE2816a102Ee049F) |

## Base Units

### Generic/Abstract Examples

| Symbol | Address | Description |
|--------|---------|-------------|
| [`foo`](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430) | `0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430` | Generic placeholder unit for examples |
| [`bar`](https://etherscan.io/token/0xCa0D8fF22509E38A6E7Cc17A6dccEB2b26E123EA) | `0xCa0D8fF22509E38A6E7Cc17A6dccEB2b26E123EA` | Generic placeholder unit for examples |
| [`baz`](https://etherscan.io/token/0x5E122f39E8DAD06dCA6e1Ed89a1ECAA0Ee104000) | `0x5E122f39E8DAD06dCA6e1Ed89a1ECAA0Ee104000` | Generic placeholder unit for examples |
| [`acme`](https://etherscan.io/token/0x44FFA0957db719EEe78E288A8411e159641f24Aa) | `0x44FFA0957db719EEe78E288A8411e159641f24Aa` | Example company/entity unit |
| [`widget`](https://etherscan.io/token/0x7385D32d8ee6f16f2Ae3732493146F689713228f) | `0x7385D32d8ee6f16f2Ae3732493146F689713228f` | Example product unit |

### Physics/Dimensional Units

| Symbol | Address | Description |
|--------|---------|-------------|
| [`meter`](https://etherscan.io/token/0x4CC76063C30Db2dD5612873Ae17CD4823c307C7e) | `0x4CC76063C30Db2dD5612873Ae17CD4823c307C7e` | Example length dimension |
| [`second`](https://etherscan.io/token/0x0DC61065a2fD440f112F08790A590fD31A866880) | `0x0DC61065a2fD440f112F08790A590fD31A866880` | Example time dimension |
| [`kilogram`](https://etherscan.io/token/0x67b86C196a7E13aC3af7cE465Cf3Ea980D35b8FB) | `0x67b86C196a7E13aC3af7cE465Cf3Ea980D35b8FB` | Example mass dimension |
| [`kg`](https://etherscan.io/token/0x665da6de0B16b10A625527F47eDfACa4f736c110) | `0x665da6de0B16b10A625527F47eDfACa4f736c110` | Abbreviated mass dimension |

### Gaming/Community Examples

| Symbol | Address | Description |
|--------|---------|-------------|
| [`sword`](https://etherscan.io/token/0xcd3a567773675d2b32263613fEdb6eAB920EA28f) | `0xcd3a567773675d2b32263613fEdb6eAB920EA28f` | Gaming item example |
| [`shield`](https://etherscan.io/token/0x4ee12ae9725f7Ef18F8cF03052a1e61c9337BB68) | `0x4ee12ae9725f7Ef18F8cF03052a1e61c9337BB68` | Gaming item example |

### Symbolic Real-World Assets

{: .warning }
> **These are symbolic units with NO inherent value or backing.**
> They have NO connection to real-world assets despite their names.

| Symbol | Address | Description |
|--------|---------|-------------|
| [`USD`](https://etherscan.io/token/0xb937B9a0fe95208894329188A32720788e099967) | `0xb937B9a0fe95208894329188A32720788e099967` | Symbolic USD (NO connection to US dollars) |
| [`ETH`](https://etherscan.io/token/0x4055c468567fBf86DaE7e483aD75b9EE78344BB2) | `0x4055c468567fBf86DaE7e483aD75b9EE78344BB2` | Symbolic ETH (distinct from anchored [$WETH](/tokens/weth/)) |
| [`BTC`](https://etherscan.io/token/0x67a006CEa7435c156299290713Df3B0cd567619B) | `0x67a006CEa7435c156299290713Df3B0cd567619B` | Symbolic BTC (NO connection to Bitcoin) |
| [`MSFT`](https://etherscan.io/token/0x006c4b92431f5584791ff74Fc0bEB2429b572faA) | `0x006c4b92431f5584791ff74Fc0bEB2429b572faA` | Symbolic MSFT (NO connection to Microsoft stock) |

## Reciprocal Units

| Symbol | Address | Base Unit |
|--------|---------|-----------|
| [`1/foo`](https://etherscan.io/token/0xECEb7691f8c5A9D4d8bA2E97E0CfE0eD5b601C8b) | `0xECEb7691f8c5A9D4d8bA2E97E0CfE0eD5b601C8b` | [`foo`](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430) |
| [`1/bar`](https://etherscan.io/token/0xDbB28A2de8A27E7e8Ea395a7fd58DD9CdA20E73E) | `0xDbB28A2de8A27E7e8Ea395a7fd58DD9CdA20E73E` | [`bar`](https://etherscan.io/token/0xCa0D8fF22509E38A6E7Cc17A6dccEB2b26E123EA) |
| [`1/meter`](https://etherscan.io/token/0x9aEEeF70d400199DDd7C48AD2e8acc9F931413d2) | `0x9aEEeF70d400199DDd7C48AD2e8acc9F931413d2` | [`meter`](https://etherscan.io/token/0x4CC76063C30Db2dD5612873Ae17CD4823c307C7e) |
| [`1/second`](https://etherscan.io/token/0x479834E7418551FbcE308c4214145E420B9901C8) | `0x479834E7418551FbcE308c4214145E420B9901C8` | [`second`](https://etherscan.io/token/0x0DC61065a2fD440f112F08790A590fD31A866880) |
| [`1/kilogram`](https://etherscan.io/token/0x2CBAf283fb52f977188d009E8B6D4B72897f3276) | `0x2CBAf283fb52f977188d009E8B6D4B72897f3276` | [`kilogram`](https://etherscan.io/token/0x67b86C196a7E13aC3af7cE465Cf3Ea980D35b8FB) |
| [`1/kg`](https://etherscan.io/token/0x081654B748f61E6CAe74aDfcC89DBCBA90AcAA3d) | `0x081654B748f61E6CAe74aDfcC89DBCBA90AcAA3d` | [`kg`](https://etherscan.io/token/0x665da6de0B16b10A625527F47eDfACa4f736c110) |

## Compound Units

### Simple Products

{: .note }
> **Canonical Form**: Terms in compound units are alphabetically sorted.
> Example: `foo*bar` becomes `bar*foo` in canonical form.

| Symbol | Canonical | Address | Description |
|--------|-----------|---------|-------------|
| `foo*bar` | [`bar*foo`](https://etherscan.io/token/0xe45897a7d5b52264708d035C03a14DE1621F0E29) | `0xe45897a7d5b52264708d035C03a14DE1621F0E29` | Product of foo and bar |
| [`meter*second`](https://etherscan.io/token/0xA0BBB690E951162A025F685c06098032F1d22c99) | `meter*second` | `0xA0BBB690E951162A025F685c06098032F1d22c99` | Product of meter and second |
| [`kg*m`](https://etherscan.io/token/0x305D8D8323dfd1d8601E465D42C7D273b09cc620) | `kg*m` | `0x305D8D8323dfd1d8601E465D42C7D273b09cc620` | Product of kg and m |
| [`kilogram*meter`](https://etherscan.io/token/0x4b29F6E86cB14B93970Fa8F6596A8a3497A5f1B1) | `kilogram*meter` | `0x4b29F6E86cB14B93970Fa8F6596A8a3497A5f1B1` | Product of kilogram and meter |
| `sword*shield` | [`shield*sword`](https://etherscan.io/token/0xD7d57d5323fB646BbC786139Ff42805f3e9dC99C) | `0xD7d57d5323fB646BbC786139Ff42805f3e9dC99C` | Gaming composite item |

### Ratios/Division

| Symbol | Address | Description |
|--------|---------|-------------|
| [`meter/second`](https://etherscan.io/token/0xCbdc3D8ca6255CbbD1a49F19AE2816a102Ee049F) | `0xCbdc3D8ca6255CbbD1a49F19AE2816a102Ee049F` | Velocity (meters per second) |
| [`foo/bar`](https://etherscan.io/token/0x3401d5A36594ec9754e13827fb6E00509F607006) | `0x3401d5A36594ec9754e13827fb6E00509F607006` | Ratio of foo to bar |
| [`second/meter`](https://etherscan.io/token/0x6aCB3b4938aC84258BC6Cb1C23d665c597d5F4AF) | `0x6aCB3b4938aC84258BC6Cb1C23d665c597d5F4AF` | Reciprocal of velocity |

### Complex Combinations

| Symbol | Address | Description |
|--------|---------|-------------|
| [`kg*m/s^2`](https://etherscan.io/token/0xEb171Bea0bB215E91B41ca6546e30aabF0Fe58Dd) | `0xEb171Bea0bB215E91B41ca6546e30aabF0Fe58Dd` | Force unit (Newtons) |

### Powers/Exponents

{: .note }
> **Exponent Division**: Uses `\` character for division in exponents.
> Example: `foo^2\3` means foo^(2/3)

| Symbol | Address | Description |
|--------|---------|-------------|
| [`foo^2`](https://etherscan.io/token/0xb1a94eCc74B567b241a0B59541e3D44BD60B302A) | `0xb1a94eCc74B567b241a0B59541e3D44BD60B302A` | Foo squared |
| [`foo^2\3`](https://etherscan.io/token/0x5AFd4791a696cdB5337a90c1dFbE586cE9A878C9) | `0x5AFd4791a696cdB5337a90c1dFbE586cE9A878C9` | Foo to the power 2/3 |
| [`bar^1\2`](https://etherscan.io/token/0x1533c600E82a4837C75D7C041a3f35173bD1f477) | `0x1533c600E82a4837C75D7C041a3f35173bD1f477` | Square root of bar |

## How to Deploy

These units are not automatically deployed. To deploy any unit:

### Using Etherscan (mainnet or Sepolia)

1. Go to [Uniteum 0.1 on Etherscan](https://etherscan.io/address/0x9df9b0501e8f6c05623b5b519f9f18b598d9b253#writeContract)
2. Connect your wallet
3. Call `multiply(string expression)` with the symbol (e.g., `"foo"`)
4. The unit will be deployed to its deterministic address
5. View the newly deployed unit at the predicted address

### Using cast (command line)

```bash
# Predict address (read-only, no gas cost)
cast call 0x9df9b0501e8f6c05623b5b519f9f18b598d9b253 \
  "product(string)(address,string)" "foo" \
  --rpc-url https://eth.llamarpc.com

# Deploy (requires wallet and gas)
cast send 0x9df9b0501e8f6c05623b5b519f9f18b598d9b253 \
  "multiply(string)(address)" "foo" \
  --rpc-url https://eth.llamarpc.com \
  --private-key $PRIVATE_KEY
```

### Using ethers.js

```javascript
const uniteum = new ethers.Contract(
  "0x9df9b0501e8f6c05623b5b519f9f18b598d9b253",
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

## Batch Deployment Script

To deploy all example units at once, use the provided script:

```bash
cd /path/to/uniteum/docs
./scripts/deploy-examples.sh
```

Or deploy to Sepolia testnet for experimentation:

```bash
./scripts/deploy-examples.sh --network sepolia
```

## See Also

- [Anchored Units (Token Reference)](/tokens/) - Real ERC-20 backed units
- [Creating Units Guide](/guides/creating-units/) - How to create your own units
- [Contracts Reference](/reference/contracts/) - Contract addresses and interfaces
