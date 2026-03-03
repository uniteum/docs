# CLAUDE.md - Data Files (`_data/`)

Conventions for all YAML data files in this directory.

## Schema & Granularity

**One schema per file.** Every entry in a data file should have the same shape. Don't mix different schemas under different keys in a single file.

✅ CORRECT: Separate files for different schemas
```
_data/contracts.yml    ← all entries have name, description, address, ens
_data/tokens.yml       ← all entries have name, symbol, mainnet, sepolia
```

❌ WRONG: Mixed schemas in one file
```yaml
# Don't do this
hub:
  address: "0x..."
  backing: "0x..."
spokes:
  usdc:
    address: "0x..."
    decimals: 6
```

## Singletons vs Collections

- **Singleton** (one thing): flat top-level fields, no wrapper key. Access as `site.data.filename.field`.
- **Collection** (many things keyed by identifier): map of entries. Access as `site.data.filename.key.field` or iterate with `for item in site.data.filename`.

```yaml
# Singleton: _data/liquid-hub.yml
address: "0x..."
backing: "0x..."
name: "Hub"
# → site.data.liquid-hub.address

# Collection: _data/liquid-spokes.yml
usdc:
  address: "0x..."
  backing: "0x..."
dai:
  address: "0x..."
  backing: "0x..."
# → site.data.liquid-spokes.usdc.address
```

## Collections: Maps not Arrays

Use maps keyed by identifier, not arrays. This enables direct lookup (`site.data.tokens.weth`) without searching.

✅ `weth:` / `usdc:` / `dai:` (keyed map)
❌ `- symbol: weth` / `- symbol: usdc` (array)

Exception: arrays are acceptable when there is no natural key or ordering is the primary concern (e.g., a list of references).

## Address Fields

**Our contracts** use deterministic deployment (Nick's deployer / CREATE2) and have identical addresses on all networks including testnets. Use a single `address` field.

✅ CORRECT: Single `address` field (our contracts)
```yaml
uniteum:
  address: "0xace41cf6d750d7ba06f4de57ac9e063246b2b090"
```

❌ WRONG: Network-split fields for our contracts
```yaml
uniteum:
  mainnet: "0xace4..."
  sepolia: "0xace4..."
```

**External contracts** (e.g., WETH, USDC) may have different addresses per network. Use per-network fields (`mainnet`, `sepolia`, etc.) only for these.

```yaml
weth:
  mainnet: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
  sepolia: "0x7b79995e5f793A07Bc00c21412e50Ecae098E7f9"
```

**Rule of thumb:** If the address is the same everywhere, use `address`. If it differs by network, use named network fields.
