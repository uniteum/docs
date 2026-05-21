---
title: Tutorial
weight: 2
---
# Tutorial: Using Solid on Etherscan

> Make a token, buy it, sell it, and swap it — all from a block explorer.

Everything here uses [Etherscan](https://etherscan.io) directly. No custom app, no frontend, no SDK.

We'll use [Hydrogen (H)](https://etherscan.io/token/{{< val "solids.H.address" >}}) as our example Solid. Any Solid works the same way.

---

## 1. Make a Solid

**Goal:** Create a new token with a built-in trading pool.

### Check if it already exists

1. Go to [NOTHING → Read Contract](https://etherscan.io/address/{{< val "solids.NOTHING.address" >}}#readContract)
2. Find **`made`**
3. Enter a `name` and `symbol` (e.g., "Hydrogen", "H")
4. Click **Query**

If `yes` = `true`, it already exists at the `home` address.
If `yes` = `false`, you can create it.

### Create it

1. Go to [NOTHING → Write Contract](https://etherscan.io/address/{{< val "solids.NOTHING.address" >}}#writeContract)
2. Connect your wallet
3. Find **`make`**
4. Enter the same `name` and `symbol`
5. Click **Write** and confirm

**What happened:**
- A new Solid was deployed at a deterministic address
- 100% of the supply went to the pool — the creator gets zero tokens
- The pool starts with a virtual 1 ETH reserve, giving the token an initial price and a permanent price floor

**Find the address:** Call `made` again with the same name and symbol. The `home` field is your Solid's contract address.

<!-- TODO: example tx hash for a make transaction -->

---

## 2. Buy tokens with ETH

**Goal:** Buy tokens from the pool by sending ETH.

### Preview

1. Go to [Hydrogen → Read Contract](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract)
2. Find **`buys`**
3. Enter an ETH amount in wei (e.g., `100000000000000000` = 0.1 ETH)
4. Click **Query**

The result is how many tokens you'd receive (18 decimals).

### Buy

1. Go to [Hydrogen → Write Contract](https://etherscan.io/token/{{< val "solids.H.address" >}}#writeContract)
2. Connect your wallet
3. Find **`buy`**
4. In the **payable amount** field at the top, enter the ETH to spend (e.g., `0.1`)
5. Click **Write** and confirm

**What happened:**
- Your ETH went into the pool
- Tokens moved from the pool to your wallet
- No tokens were minted — the supply is fixed forever

**Verify:** Call `balanceOf` on Read Contract with your wallet address.

<!-- TODO: example tx hash for a buy transaction -->

---

## 3. Sell tokens for ETH

**Goal:** Sell tokens back to the pool and receive ETH.

### Preview

1. On [Hydrogen → Read Contract](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract)
2. Find **`sells`**
3. Enter the token amount to sell (in wei, 18 decimals)
4. Click **Query**

The result is how much ETH you'd receive (in wei).

### Sell

1. Go to [Hydrogen → Write Contract](https://etherscan.io/token/{{< val "solids.H.address" >}}#writeContract)
2. Find **`sell`**
3. Enter `s` — the amount to sell (in wei, 18 decimals)
4. Click **Write** and confirm

**What happened:**
- Tokens moved from your wallet back into the pool
- ETH was sent to your wallet
- No approval needed — you're selling your own tokens directly

**Verify:** Check your wallet's ETH balance, or call `balanceOf` again.

<!-- TODO: example tx hash for a sell transaction -->

---

## 4. Swap one Solid for another

**Goal:** Trade Hydrogen (H) for Helium (He) in a single transaction.

This sells H for ETH internally, then immediately buys He with that ETH — atomically, in one transaction.

### Preview

1. On [Hydrogen → Read Contract](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract)
2. Find **`sellsFor`**
3. Enter:
   - `that`: `{{< val "solids.He.address" >}}` (Helium's address)
   - `s`: amount of H to trade (in wei)
4. Click **Query**

The result is how many He tokens you'd receive.

### Swap

1. Go to [Hydrogen → Write Contract](https://etherscan.io/token/{{< val "solids.H.address" >}}#writeContract)
2. Find **`sellFor`**
3. Enter:
   - `that`: `{{< val "solids.He.address" >}}`
   - `s`: amount of H to trade (in wei)
4. Click **Write** and confirm

**What happened:**
- Your H tokens went into the Hydrogen pool
- ETH moved internally from Hydrogen's pool to Helium's pool
- He tokens moved from Helium's pool to your wallet
- All in one transaction — no intermediate steps, no approvals

**Verify:** Call `balanceOf` on the [Helium contract](https://etherscan.io/token/{{< val "solids.He.address" >}}#readContract) with your wallet address.

<!-- TODO: example tx hash for a sellFor transaction -->

---

## Quick reference

| Action | Function | Payable | No approval needed |
|:-------|:---------|:--------|:-------------------|
| Create | [`make(name, symbol)`](https://etherscan.io/address/{{< val "solids.NOTHING.address" >}}#writeContract#F{{< val "solid" "write" "make(name, symbol)" "f" >}}) | No | — |
| Check existence | [`made(name, symbol)`](https://etherscan.io/address/{{< val "solids.NOTHING.address" >}}#readContract#F{{< val "solid" "read" "made(name, symbol)" "f" >}}) | — | — |
| Buy | [`buy()`](https://etherscan.io/token/{{< val "solids.H.address" >}}#writeContract#F{{< val "solid" "write" "buy()" "f" >}}) | **Yes** (send ETH) | — |
| Sell | [`sell(s)`](https://etherscan.io/token/{{< val "solids.H.address" >}}#writeContract#F{{< val "solid" "write" "sell(s)" "f" >}}) | No | Yes |
| Swap | [`sellFor(that, s)`](https://etherscan.io/token/{{< val "solids.H.address" >}}#writeContract#F{{< val "solid" "write" "sellFor(that, s)" "f" >}}) | No | Yes |
| Preview buy | [`buys(e)`](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract#F{{< val "solid" "read" "buys(e)" "f" >}}) | — | — |
| Preview sell | [`sells(s)`](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract#F{{< val "solid" "read" "sells(s)" "f" >}}) | — | — |
| Preview swap | [`sellsFor(that, s)`](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract#F{{< val "solid" "read" "sellsFor(that, s)" "f" >}}) | — | — |
| Pool state | [`pool()`](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract#F{{< val "solid" "read" "pool()" "f" >}}) | — | — |
| Your balance | [`balanceOf(address)`](https://etherscan.io/token/{{< val "solids.H.address" >}}#readContract#F{{< val "solid" "read" "balanceOf(account)" "f" >}}) | — | — |

All amounts use 18 decimals. 1 token = `1000000000000000000` wei.

## What to try next

- [Protocol](/solid/protocol) — how the pool, pricing, and price floor work
- [Gift Certificates](/solid/use-cases/gift-certificates/) — a use case showing what you can build with a Solid
- [Game Currencies](/solid/use-cases/game-currencies/) — using Solids for game economy design
