# Example Units Deployment Summary

## Overview

This document catalogs all floating example units (`foo`, `bar`, etc.) used throughout the Uniteum documentation, along with their deterministically predicted addresses.

**Key Decisions:**
1. ✅ Deploy real units on both mainnet and Sepolia (addresses are identical due to CREATE2)
2. ✅ Link to actual contracts in documentation (not just theoretical examples)
3. ✅ Make examples interactive - users can inspect, deploy, and experiment
4. ✅ Maintain comprehensive reference with all addresses

## Files Created

### Data & Reference
- **`_data/example-units.yml`** - Structured data file with all units, addresses, and descriptions
- **`reference/floating-units.md`** - User-facing reference page with tables and links
- **`EXAMPLE_UNITS_SUMMARY.md`** (this file) - Internal summary for project maintainers

### Scripts
- **`scripts/fetch-example-addresses.sh`** - Query contract to predict all addresses
- **`scripts/deploy-examples.sh`** - Deploy all units to mainnet or Sepolia
- **`scripts/predict-unit-addresses.sh`** - Educational script explaining CREATE2 calculation

## Total Units Cataloged

| Category | Count | Examples |
|----------|-------|----------|
| **Base Units** | 14 | `foo`, `bar`, `meter`, `second`, `USD`, `ETH` |
| **Reciprocals** | 6 | `1/foo`, `1/bar`, `1/meter` |
| **Compounds** | 11 | `foo*bar`, `meter/second`, `kg*m/s^2`, `foo^2` |
| **TOTAL** | **31** | |

## Key Addresses (Selected Examples)

### Most Common Examples
- `foo`: [`0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430`](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430)
- `bar`: [`0xCa0D8fF22509E38A6E7Cc17A6dccEB2b26E123EA`](https://etherscan.io/token/0xCa0D8fF22509E38A6E7Cc17A6dccEB2b26E123EA)
- `1/foo`: [`0xECEb7691f8c5A9D4d8bA2E97E0CfE0eD5b601C8b`](https://etherscan.io/token/0xECEb7691f8c5A9D4d8bA2E97E0CfE0eD5b601C8b)

### Physics Examples
- `meter`: [`0x4CC76063C30Db2dD5612873Ae17CD4823c307C7e`](https://etherscan.io/token/0x4CC76063C30Db2dD5612873Ae17CD4823c307C7e)
- `second`: [`0x0DC61065a2fD440f112F08790A590fD31A866880`](https://etherscan.io/token/0x0DC61065a2fD440f112F08790A590fD31A866880)
- `meter/second`: [`0xCbdc3D8ca6255CbbD1a49F19AE2816a102Ee049F`](https://etherscan.io/token/0xCbdc3D8ca6255CbbD1a49F19AE2816a102Ee049F)
- `kg*m/s^2` (force): [`0xEb171Bea0bB215E91B41ca6546e30aabF0Fe58Dd`](https://etherscan.io/token/0xEb171Bea0bB215E91B41ca6546e30aabF0Fe58Dd)

### Cautionary Examples (Floating, NOT Anchored)
- `USD` (floating): [`0xb937B9a0fe95208894329188A32720788e099967`](https://etherscan.io/token/0xb937B9a0fe95208894329188A32720788e099967)
- `ETH` (floating): [`0x4055c468567fBf86DaE7e483aD75b9EE78344BB2`](https://etherscan.io/token/0x4055c468567fBf86DaE7e483aD75b9EE78344BB2)
- `BTC` (floating): [`0x67a006CEa7435c156299290713Df3B0cd567619B`](https://etherscan.io/token/0x67a006CEa7435c156299290713Df3B0cd567619B)

## Important Notes

### Canonical Form Differences

Some units have different canonical forms than input (alphabetically sorted):

| Input | Canonical | Address |
|-------|-----------|---------|
| `foo*bar` | `bar*foo` | `0xe45897a7d5b52264708d035C03a14DE1621F0E29` |
| `sword*shield` | `shield*sword` | `0xD7d57d5323fB646BbC786139Ff42805f3e9dC99C` |

### Exponent Division

Uses `\` (backslash) for division in exponents:
- Input: `foo^2\3` (foo to the power 2/3)
- In YAML/code: Must escape as `foo^2\\3`
- Canonical: `foo^2\3`

## Deployment Status

**Current Status**: Addresses predicted but units NOT yet deployed

**Next Steps**:
1. Review this summary
2. Test deployment script in dry-run mode:
   ```bash
   cd /home/paul/git/uniteum/docs
   ./scripts/deploy-examples.sh --network sepolia --dry-run
   ```
3. Deploy to Sepolia for testing:
   ```bash
   export PRIVATE_KEY=0x...
   ./scripts/deploy-examples.sh --network sepolia
   ```
4. Deploy to mainnet when ready:
   ```bash
   ./scripts/deploy-examples.sh --network mainnet
   ```

## Usage in Documentation

### Recommended Link Format

For base/common examples:
```markdown
Try creating a [`foo`](https://etherscan.io/token/0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430) unit...
```

For compounds:
```markdown
The [`meter/second`](https://etherscan.io/token/0xCbdc3D8ca6255CbbD1a49F19AE2816a102Ee049F) unit represents velocity...
```

### When to Use Mainnet vs Sepolia Links

- **Concept explanations**: Use mainnet links (authoritative)
- **Tutorial "try it yourself"**: Use Sepolia links (safe for experimentation)
- **Can link both**: "View on [Mainnet](https://etherscan.io/...) | [Sepolia](https://sepolia.etherscan.io/...)"

### Anchored Unit Shorthands

Continue using shorthands like `$WETH`, `$USDC` in documentation text, but:
1. Link first occurrence to token reference pages
2. Add callout at top: "We use [$WETH](/reference/anchored-units/weth/), [$USDC](/reference/anchored-units/usdc/), etc. as shorthands. See [Token Reference](/reference/anchored-units/)."
3. In code examples, show real addresses

## Documentation Updates Needed

After deploying, update these files to link to example units:

1. **`getting-started.md`** - Link first `foo` example
2. **`concepts/units.md`** - Link floating unit examples
3. **`concepts/forge.md`** - Link triad examples
4. **`concepts/triads.md`** - Link compound units
5. **`concepts/arbitrage.md`** - Link multi-unit examples
6. **`guides/creating-units.md`** - Link step-by-step examples
7. **`guides/forging.md`** - Link forge operation examples
8. **`use-cases.md`** - Link gaming/community examples

## Future Enhancements

1. **Jekyll Include Snippet**: Create `{% include unit.html symbol="foo" %}` for consistent linking
2. **Automated Tests**: Verify all addresses match predictions
3. **Status Badges**: Show deployed/not-deployed status for each unit
4. **Interactive Explorer**: Build tool to browse all units and their relationships
5. **Gas Cost Estimates**: Document deployment costs for each unit type

## Questions for Review

1. **Deploy all 31 units?** Or subset (just foo, bar, meter for now)?
2. **Network preference?** Deploy to Sepolia only? Mainnet only? Both?
3. **Deployment timing?** Before or after documentation update?
4. **Gas budget?** Estimate: ~$2-5 per unit deployment on mainnet
5. **Who deploys?** Main deployer EOA (0.eoa.uniteum.eth) or separate account?

## Reference Commands

```bash
# Predict address without deploying
cast call 0x9df9b0501e8f6c05623b5b519f9f18b598d9b253 \
  "product(string)(address,string)" "foo" \
  --rpc-url https://eth.llamarpc.com

# Check if unit is deployed
cast code 0x966108210F3B2eC0f01B646a61Ce7D8F1aDE7430 \
  --rpc-url https://eth.llamarpc.com

# Deploy single unit
cast send 0x9df9b0501e8f6c05623b5b519f9f18b598d9b253 \
  "multiply(string)(address)" "foo" \
  --rpc-url https://eth.llamarpc.com \
  --private-key $PRIVATE_KEY

# Deploy all units (batch)
./scripts/deploy-examples.sh --network mainnet
```

## Complete Address List

See [`_data/example-units.yml`](_data/example-units.yml) for the complete structured list.

See [`reference/floating-units.md`](reference/floating-units.md) for the user-facing reference page.

---

**Generated**: 2024-12-12
**Contract**: Uniteum 0.1 "1" at `0x9df9b0501e8f6c05623b5b519f9f18b598d9b253`
**Creator**: Paul Reinholdtsen (reinholdtsen.eth)
