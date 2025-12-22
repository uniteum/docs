# Uniteum Documentation

This repository contains the documentation site for Uniteum, built with Jekyll and hosted on GitHub Pages.

## User-Facing Documentation

The main documentation is organized as:

- [index.md](index.md) - Homepage
- [getting-started.md](getting-started.md) - Quick start guide
- [economics-of-one.md](economics-of-one.md) - The "1" token value hypothesis
- [use-cases.md](use-cases.md) - What you can build
- [safety.md](safety.md) - Risks and disclaimers
- [known-issues.md](known-issues.md) - Version history and bug reporting
- [legal.md](legal.md) - Legal notices
- [license.md](license.md) - Licensing information

Additional documentation is organized under:
- `/concepts/` - Core concepts and mechanics
- `/reference/` - Technical reference and contract details
- `/research/` - Research papers and theoretical foundations

## Site Configuration

- `_config.yml` - Jekyll site configuration
- `_data/` - Contract addresses, navigation, and other data files
- `_includes/` - Reusable templates and components
- `_layouts/` - Page layouts
- `assets/` - Images, CSS, and other static assets

<details>
<summary><strong>Meta Documents (Collaboration & Development)</strong></summary>

These documents support our development process and collaboration with Claude. They're organized in the `.meta/` directory but aren't part of the user-facing documentation.

### Primary References
- [CLAUDE.md](CLAUDE.md) - **Main instructions for Claude Code** - Project overview, conventions, and guidelines (kept at root)
- [.meta/STYLE_GUIDE.md](.meta/STYLE_GUIDE.md) - Writing style and formatting standards

### Development Summaries
- [.meta/CONTRACT_REFERENCES.md](.meta/CONTRACT_REFERENCES.md) - How contract addresses are referenced in docs
- [.meta/ENV_INTEGRATION.md](.meta/ENV_INTEGRATION.md) - Environment setup and Jekyll integration
- [.meta/SCRIPTS_SUMMARY.md](.meta/SCRIPTS_SUMMARY.md) - Available scripts and their usage

### Content Management
- [.meta/EXAMPLE_UNITS_SUMMARY.md](.meta/EXAMPLE_UNITS_SUMMARY.md) - Catalog of example units used across docs
- [.meta/SETUP_SUMMARY.md](.meta/SETUP_SUMMARY.md) - Site setup and initialization details

### Code Quality
- [.meta/DUPLICATION_AUDIT.md](.meta/DUPLICATION_AUDIT.md) - Content duplication analysis
- [.meta/DEDUPLICATION_SUMMARY.md](.meta/DEDUPLICATION_SUMMARY.md) - Deduplication actions taken
- [.meta/REFACTORING_SUMMARY.md](.meta/REFACTORING_SUMMARY.md) - Major refactoring decisions

</details>

## Local Development

```bash
# Install dependencies
bundle install

# Run local server
bundle exec jekyll serve

# Build site
bundle exec jekyll build
```

The site will be available at `http://localhost:4000`.

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch.

Live site: [uniteum.one](https://uniteum.one) → [uniteum.github.io](https://uniteum.github.io)
