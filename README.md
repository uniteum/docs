# Uniteum Documentation

This repository contains the documentation site for Uniteum, built with [Hugo](https://gohugo.io) (theme: [hugo-book](https://github.com/alex-shpak/hugo-book)) and deployed to Cloudflare Workers.

Live site: [uniteum.one](https://uniteum.one)

## User-Facing Documentation

Top-level sections under `content/`:

- [content/_index.md](content/_index.md) — Homepage
- [content/liquid/](content/liquid/) — Liquid protocol
- [content/solid/](content/solid/) — Solid protocol
- [content/uniteum/](content/uniteum/) — Algebraic Uniteum protocol
- [content/lepton/](content/lepton/) — Minimal token factory
- [content/locale/](content/locale/) — Deterministic on-chain reference data
- [content/reflector/](content/reflector/) — 1:1 mirror factory (Reflector)
- [content/unispring/](content/unispring/) — Family of permissionless V4 contracts

## Site Configuration

- `hugo.toml` — Hugo site configuration
- `data/` — Contract addresses, function tables, and other YAML data
- `layouts/shortcodes/` — Custom shortcodes for Etherscan links and data lookups
- `layouts/partials/docs/inject/head.html` — Favicon, OG meta, KaTeX
- `layouts/_markup/render-link.html` — Render hook that opens external links in new tabs
- `static/` — Images and other static assets served at the root
- `themes/hugo-book/` — Theme submodule

## Local Development

```bash
# After cloning, initialize the theme submodule
git submodule update --init --recursive

# Run local server (hot reload)
hugo server

# Build to ./public/
hugo --minify
```

The site will be available at `http://localhost:1313`.

## Deployment

The site is automatically deployed to Cloudflare Workers on push to `main` via [.github/workflows/deploy.yml](.github/workflows/deploy.yml).

Required repo secrets: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`. The Worker is configured in [wrangler.toml](wrangler.toml).

<details>
<summary><strong>Meta Documents (Collaboration & Development)</strong></summary>

These documents support our development process and collaboration with Claude. They're organized in the `.meta/` directory but aren't part of the user-facing documentation.

### Primary References
- [CLAUDE.md](CLAUDE.md) — Main instructions for Claude Code (kept at root)
- [.meta/STYLE_GUIDE.md](.meta/STYLE_GUIDE.md) — Writing style and formatting standards

### Development Summaries
- [.meta/CONTRACT_REFERENCES.md](.meta/CONTRACT_REFERENCES.md) — How contract addresses are referenced in docs
- [.meta/SCRIPTS_SUMMARY.md](.meta/SCRIPTS_SUMMARY.md) — Available scripts and their usage

### Content Management
- [.meta/EXAMPLE_UNITS_SUMMARY.md](.meta/EXAMPLE_UNITS_SUMMARY.md) — Catalog of example units used across docs

### Code Quality
- [.meta/DUPLICATION_AUDIT.md](.meta/DUPLICATION_AUDIT.md) — Content duplication analysis
- [.meta/DEDUPLICATION_SUMMARY.md](.meta/DEDUPLICATION_SUMMARY.md) — Deduplication actions taken
- [.meta/REFACTORING_SUMMARY.md](.meta/REFACTORING_SUMMARY.md) — Major refactoring decisions

</details>
