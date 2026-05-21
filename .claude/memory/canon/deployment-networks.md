---
name: deployment-networks
description: All contracts use identical addresses across every network (deterministic). The data/*.yml addresses are live on Arbitrum now; mainnet follows in days-to-weeks.
metadata:
  type: project
---

**All Uniteum contracts deploy to identical addresses on every network**
(deterministic CREATE2). The addresses currently in `data/*.yml` are live on
**Arbitrum now**; they will **also** be on **mainnet in a few days to weeks**
(as of 2026-05-21). Same address string everywhere — only the explorer *host*
differs per chain.

**Why:** Stated by the user 2026-05-21 while discussing making Etherscan links
network-configurable.

**How to apply:**

- Because the address is identical across chains, configurability is **purely a
  host swap**: `etherscan.io` ↔ `arbiscan.io` ↔ `sepolia.etherscan.io`. No
  per-contract address data is needed — do NOT add per-network address fields or
  a per-contract `network:` field to the data; that would be wasted churn.
- The site hardcodes `https://etherscan.io/...` ([CLAUDE.md:184-207](CLAUDE.md#L184-L207),
  5 shortcodes, ~19 raw markdown URLs). Until mainnet deploy lands, etherscan.io
  links to the newer contracts resolve to a not-yet-deployed address. The fix is
  to default the explorer host to Arbitrum now and flip (or add a switcher)
  once mainnet is live.
- The clean model: a single site-wide "current network" (host) + optionally a
  client-side dropdown that rewrites every link's host. Address stays constant,
  so a global switcher is correct for the whole site — no per-page logic.
- After mainnet deploy, both Arbiscan and Etherscan links work, so a dropdown
  needs no further changes; only the default may change.

Related: [[etherscan-link-architecture]] (when written) for the
configurable-explorer plan.
