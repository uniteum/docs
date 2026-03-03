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
