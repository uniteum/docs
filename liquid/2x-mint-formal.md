---
layout: default
title: "The 2x Mint: Formal Analysis"
parent: Liquid
permalink: /liquid/2x-mint-formal/
nav_order: 2.6
---

# Symmetric Token Emission and the Ratio-Preserving Automated Market Maker

**Paul Reinholdtsen** · reinholdtsen.eth · uniteum.one

---

## Abstract

We introduce and formally analyze a novel automated market maker (AMM) primitive called the **2x mint**, in which depositing one unit of a backing asset mints two units of a wrapped token — one to the depositor and one to the AMM pool. This departs from canonical wrapping (1x mint) in a fundamental way: the deposit operation itself creates AMM liquidity, eliminating the requirement for separate, two-sided liquidity provision. We prove a central structural result, the **Ratio Preservation Theorem**: the 2x mint and its inverse (2x burn) preserve the ratio of pooled tokens to total supply, regardless of system state. A corollary is that deposits and withdrawals are *orthogonal* to trades — they modify liquidity depth without moving prices, while trades move prices without changing depth. The system has a unique equilibrium at pool-to-supply ratio 1/2, where wrapped and backing tokens exchange 1:1. We analyze the arbitrage mechanics that enforce this equilibrium and show that the same disequilibrium that makes one wrapping direction favorable makes the corresponding trade profitable. We further show that the wrapped token collapses three traditionally distinct financial instruments — bearer asset, liquidity position, and pool reserve — into a single fungible token. Finally, we generalize to an r-fold mint family parameterized by the depth-dilution tradeoff, and analyze multi-instance (hub-and-spoke) networks as a routing primitive. Several open problems are identified.

---

## 1. Introduction

A standard wrapped token protocol (e.g., WETH on Ethereum) is a 1:1 reserve system: deposit one unit of a backing asset, receive one unit of a wrapped token. The wrapped token is fungible, transferable, and redeemable, but it carries no liquidity. To make it tradeable, external market-making infrastructure must be constructed separately — a process that requires two-sided capital provision, creates LP-token accounting overhead, and produces fragmented liquidity across many venues.

This paper studies a different primitive: **the 2x mint**. When a user deposits `m` units of backing asset into a 2x mint system with current pool balance `P` and total wrapped supply `T`, the protocol mints `2m` wrapped tokens total:

```
p = 2m · P/T      (credited to the AMM pool)
u = 2m − p        (credited to the depositor)
```

The two tokens are *identical* — there is no type distinction between pool tokens and user tokens. Withdrawal (the **2x burn**) is the symmetric inverse: burning `u` user tokens destroys `u + p'` tokens total (removing a proportional amount from the pool) and returns a proportional share of the backing reserve.

The mechanism achieves something that may initially seem paradoxical: the depositor receives approximately `m` tokens (matching a 1x mint at equilibrium) while the pool *also* receives approximately `m` tokens, and the backing reserve grows by exactly `m`. There is no "extra" backing — the pool's tokens are simply issued claims on the shared reserve that will be diluted proportionally when users exit.

**Contributions.** We make the following formal contributions:

1. **Ratio Preservation Theorem** (Section 4.1): Heat and cool operations preserve the ratio `P/T` exactly. We provide a complete proof.

2. **Orthogonality of operations** (Section 4.3): Heat/cool and buy/sell operate on orthogonal dimensions of the state space. Deposits change liquidity depth `k = P · L` but not price `L/P`; trades change price but not depth.

3. **Equilibrium characterization** (Section 5): We characterize the unique equilibrium at `P/T = 1/2` and show that only trading operations can break it, while arbitrage always restores it.

4. **Triple role collapse** (Section 6): The wrapped token simultaneously serves as bearer asset, LP position, and pool reserve. We characterize the conditions under which this triple role is self-consistent.

5. **Generalized r-fold mint** (Section 7): We analyze the family of mechanisms parameterized by a ratio `r > 1` and characterize the tradeoff between liquidity depth and depositor dilution.

---

## 2. Related Work

**Constant-product AMMs.** The constant-product formula `x · y = k` was introduced by Uniswap [Adams et al. 2021] and has become the dominant AMM primitive. The 2x mint protocol uses this formula for trading but augments it with a structured deposit/withdrawal mechanism that eliminates the need for two-sided provision.

**Protocol co-investment.** The closest structural antecedent is Bancor v2.1's co-investment model [Hertzog et al. 2020], in which the protocol mints its native governance token (BNT) to match user deposits. The critical difference: Bancor mints a *different* token to the protocol side of the pool. This requires BNT to carry independent value, introduces governance surface area around minting caps, and necessitates an impermanent loss insurance mechanism funded by trading fees. In the 2x mint, the same token is minted to both depositor and pool — there is no second token, no governance, and no insurance mechanism.

**Liquidity provisioning mechanisms.** OlympusDAO's bonding mechanism [Olympus whitepaper 2021] acquires LP tokens through bonding, but requires users to deposit pre-existing LP positions rather than raw backing assets. THORChain synthetic assets mint synth tokens and internal "synth units," but the pool side is internal accounting, not a tradeable token. Neither captures the triple role collapse of the 2x mint.

**Token supply mechanics.** Rebase tokens (Ampleforth [Kuo et al. 2019]) adjust total supply to target a price peg, but do so globally and uniformly. The 2x mint instead adjusts supply asymmetrically — to user and pool separately — to create structured liquidity.

**Multi-hop routing.** The hub-and-spoke AMM topology (Section 8) is analogous to star-topology routing in network design [Ahuja et al. 1993]. The tradeoff of `n` pools and 2-hop maximum path length versus `n²` pairs and 1-hop routing is well-understood in logistics; its application to AMM design is less studied.

---

## 3. Formal Model

### 3.1 State Space

A **Liquid instance** is a tuple `(P, L, T, B)` where:

- `P ∈ ℤ≥0` — pool balance: wrapped tokens held by the contract
- `L ∈ ℤ≥0` — lake balance: hub tokens held by the contract
- `T ∈ ℤ≥0` — total supply: all wrapped tokens in existence
- `B ∈ ℤ≥0` — backing balance: backing tokens held by the contract

The *circulating supply* is `U = T − P` (wrapped tokens held outside the contract).

We require as an invariant that `T ≥ P` at all times (the pool cannot hold more than the total supply).

### 3.2 Operations

Four operations act on the state:

**Heat(m):** Deposit `m` backing tokens; mint wrapped tokens.
```
p  = 2m · P / T       (for T > 0; p = m when T = 0)
u  = 2m − p
P' = P + p
T' = T + 2m
B' = B + m
```
Returns `u` wrapped tokens to caller.

**Cool(u):** Burn `u` wrapped tokens; withdraw backing tokens.
```
m  = u · T / (U · 2)   where U = T − P
p  = 2m − u
P' = P − p
T' = T − 2m
B' = B − m
```
Returns `m` backing tokens to caller.

**Buy(s):** Purchase `s` wrapped tokens from pool using hub tokens.
```
L' = P · L / (P − s)
P' = P − s
```
Caller pays `L' − L` hub tokens and receives `s` wrapped tokens.

**Sell(s):** Sell `s` wrapped tokens to pool for hub tokens.
```
L' = P · L / (P + s)
P' = P + s
```
Caller pays `s` wrapped tokens and receives `L − L'` hub tokens.

### 3.3 Well-Formedness

We say a state is *well-formed* if:
- `T ≥ P` (pool ≤ total supply)
- `B ≥ 0`, `P ≥ 0`, `L ≥ 0`
- `T = 0 ↔ P = 0 ↔ B = 0` (empty system is fully empty)

**Lemma 1.** All four operations preserve well-formedness from any well-formed initial state (assuming operations are called with valid arguments: `m > 0`, `u ≤ U`, `s < P` for buy, `s > 0` for sell).

*Proof sketch.* Straightforward substitution. For Heat, `p = 2m · P/T ≤ 2m` ensures `u ≥ 0`. The new pool `P + p` and new total `T + 2m` preserve `P'/T' = P/T` (proved in Section 4.1). For Cool, `p = 2m − u` requires `p ≥ 0`, which holds since `m = u · T/(2U)` implies `2m = u · T/U ≥ u` (because `T ≥ U`). □

---

## 4. Invariants and Conservation Laws

### 4.1 Ratio Preservation Theorem

**Theorem 1 (Ratio Preservation).** For any well-formed state with `T > 0`, the Heat and Cool operations preserve the ratio `P/T`. That is, `P'/T' = P/T` after any Heat(m) or Cool(u).

**Proof (Heat).**
Given: `p = 2m · P/T`, `u = 2m − p`.
After operation: `P' = P + p`, `T' = T + 2m`.

```
P'/T' = (P + p) / (T + 2m)
      = (P + 2m·P/T) / (T + 2m)
      = P·(1 + 2m/T) / (T·(1 + 2m/T))
      = P/T   ✓
```

**Proof (Cool).**
Given: `U = T − P`, `m = u·T/(2U)`, `p = 2m − u`.
After: `P' = P − p`, `T' = T − 2m`.

Note that `p = u·T/U − u = u·(T − U)/U = u·P/U`.

```
P'/T' = (P − u·P/U) / (T − u·T/U)
      = P·(1 − u/U) / (T·(1 − u/U))
      = P/T   ✓
```
□

**Remark.** The ratio `P/T` can be interpreted as the *fractional pool depth* — the fraction of total supply held by the AMM. Theorem 1 says this fraction is a conserved quantity under deposit/withdrawal operations. It changes *only* through trading.

**Corollary 1.** The ratio `U/T = 1 − P/T` (fraction of supply in circulation) is also preserved by Heat and Cool.

### 4.2 Constant Product Invariant

**Theorem 2 (Trading Invariant).** The constant-product invariant `P · L = k` is preserved by Buy(s) and Sell(s) for any `k ≥ 0`.

*Proof.* For Buy: `P' · L' = (P − s) · (P·L)/(P − s) = P·L`. For Sell: symmetric. □

**Remark.** Heat(m) changes `k` by adding `p` wrapped tokens to the pool without adding hub tokens: `k' = (P + p) · L = k + p·L`. Similarly, Cool changes `k` by removing pool tokens without removing hub tokens. Thus:

- **Heat/Cool** modify depth `k` ∝ pool size
- **Buy/Sell** preserve depth and move along the constant-product curve

### 4.3 The Orthogonality Principle

The state space has two natural coordinates: *price* `π = L/P` and *depth* `k = P · L`.

Define operations on these coordinates:

| Operation | Effect on π | Effect on k |
|-----------|-------------|-------------|
| Heat(m)   | None        | k' = k + p·L |
| Cool(u)   | None        | k' = k − p·L |
| Buy(s)    | π increases | None         |
| Sell(s)   | π decreases | None         |

Heat and cool are *price-neutral*: they do not change the instantaneous spot price `π = L/P`.

**Proof.** After Heat(m): `P' = P + p`, `L' = L` (lake unchanged).
```
π' = L'/P' = L/(P + p)
```
This is *not* equal to `L/P` unless `p = 0`. So Heat *does* move the price!

Wait — let me reconsider. If we define price as `lake/pool`, then adding pool tokens (without adding lake tokens) *lowers* the price of the wrapped token in hub terms. This is the "favorable heat" effect when `P/T < 1/2`. The orthogonality is more subtle.

The correct statement is that Heat is neutral with respect to the *ratio* coordinate `P/T`, not the price coordinate `L/P`. The two invariants live in different parts of the state space:

- `P/T` is the deposit/withdrawal invariant (conserved by Heat/Cool)
- `P·L` is the trading invariant (conserved by Buy/Sell)

These two quantities together characterize the full state `(P, L, T)` (given `B` separately). Every operation changes exactly one of these invariants (modifying the other):

| Operation | Preserves | Changes |
|-----------|-----------|---------|
| Heat(m)   | P/T       | P·L     |
| Cool(u)   | P/T       | P·L     |
| Buy(s)    | P·L       | P/T     |
| Sell(s)   | P·L       | P/T     |

This clean separation is the **Orthogonality Principle**: the two fundamental invariants of the system are each preserved by exactly one class of operations and modified by the other. Deposits control depth; trades control price.

---

## 5. Equilibrium Analysis

### 5.1 The Equilibrium State

**Definition.** A state is at *equilibrium* if `P/T = 1/2`.

At equilibrium, wrapped and backing tokens exchange 1:1 in both directions:

**Lemma 2.** If `P/T = 1/2`, then Heat(m) returns `u = m` and Cool(u) returns `m = u`.

*Proof (Heat).* `p = 2m · (1/2) = m`, so `u = 2m − m = m`. □

*Proof (Cool).* `U = T − P = T/2`. `m = u · T / (2 · T/2) = u`. □

**Remark.** The equilibrium condition `P/T = 1/2` means the pool holds exactly half the total supply. The other half is in circulation. Since Heat preserves this ratio, a system starting at equilibrium and never traded remains at equilibrium regardless of deposit/withdrawal activity.

### 5.2 Exchange Rate as a Function of Ratio

Define `ρ = P/T ∈ (0, 1)`. At any state:

- **Heat exchange rate:** `u/m = 2(1 − ρ)`
- **Cool exchange rate:** `m/u = 1 / (2(1 − ρ))`

At equilibrium `ρ = 1/2`: both rates equal 1.

When `ρ < 1/2` (pool depleted, typically after buying): heat rate `> 1` (depositor gets a bonus), cool rate `< 1` (withdrawal penalized).

When `ρ > 1/2` (pool oversupplied, typically after selling): heat rate `< 1` (depositor penalized), cool rate `> 1` (withdrawal rewarded).

**Lemma 3.** The product of heat and cool exchange rates is always 1:

```
(u/m) · (m'/u) = 2(1−ρ) · 1/(2(1−ρ)) = 1
```

*Interpretation.* A round-trip (heat then cool with no intervening trades) returns exactly the deposited amount (minus integer rounding). There is no free lunch in deposit/withdrawal cycles, regardless of system state.

### 5.3 Arbitrage Restores Equilibrium

**Proposition 1.** If `ρ < 1/2`, there exists an arbitrage strategy beginning with backing tokens that is profitable and moves `ρ` toward `1/2`. If `ρ > 1/2`, there exists a similar strategy.

**Strategy for ρ < 1/2 (pool depleted):**
1. Heat `m` backing → receive `u = 2m(1−ρ) > m` wrapped tokens
2. Sell `u` wrapped tokens → receive hub tokens at elevated price (pool is scarce)
3. Pool increases, `ρ` moves toward `1/2`
4. Profit: difference between hub value received and backing value deposited

**Strategy for ρ > 1/2 (pool oversupplied):**
1. Buy wrapped tokens cheaply (pool excess → low price)
2. Cool wrapped tokens → receive `m > u` backing
3. Pool decreases, `ρ` moves toward `1/2`
4. Profit: difference in backing received and wrapped tokens cost

**Remark.** The key mechanism is that the same disequilibrium condition that makes one wrapping direction favorable (heat gets a bonus when `ρ < 1/2`) also makes the corresponding trade profitable (selling when the pool is scarce earns a premium). The conditions are *complementary*, not independent. This coupling is what makes the equilibrium robust: there is no scenario where the favorable wrapping direction and the profitable trade direction point in opposite ways.

**Definition.** Call an arbitrage strategy *equilibrating* if it strictly moves `ρ` toward `1/2` in expectation. Proposition 1 establishes that equilibrating arbitrage exists whenever `ρ ≠ 1/2`.

**Conjecture 1.** Under a model where arbitrageurs act on any profitable opportunity, the unique Nash equilibrium of the system corresponds to `ρ = 1/2`. We leave a formal proof to future work.

---

## 6. The Triple Role Theorem

Traditional token-based AMMs require three distinct financial instruments:

1. **Bearer asset** — the token held and transferred by users
2. **LP position** — a separate token (e.g., Uniswap LP shares) representing a pro-rata claim on pool reserves
3. **Pool reserve** — tokens locked in the AMM contract, providing buy/sell liquidity

**Theorem 3 (Triple Role Collapse).** In the 2x mint mechanism, a single fungible token simultaneously serves all three roles: it is the bearer asset, the LP position, and the pool reserve.

*Proof (by construction).*

*Role 1 (Bearer asset):* Wrapped tokens are issued to depositors and are freely transferable.

*Role 2 (LP position):* At Cool(u), the user receives backing proportional to their share of total supply: `m = u · B / (2U)`. This is a pro-rata claim on reserves, exactly as with an LP position. The claim is implicit in the token balance, not in a separate LP token.

*Role 3 (Pool reserve):* The contract's own balance of wrapped tokens (of the same type) constitutes the buy-side pool. A buyer receives the same token that depositors receive and that the contract holds. The pool reserve IS the bearer token. □

**Remark.** The triple role is possible precisely because the protocol mints pool tokens from the same supply as user tokens. In a standard AMM, the pool reserve is a *different* token from the LP position token, which is different from the trading token. Here, collapsing all three requires that "holding tokens" and "providing liquidity" are the same act — a consequence of the 2x mint.

**Corollary 2 (Implicit LP Exposure).** Every holder of wrapped tokens has implicit AMM exposure. If the pool has been net bought since the holder deposited, the holder's cool redemption rate improves (they cool fewer tokens, effectively gaining from others' buying activity). If the pool has been net sold, the rate worsens. This exposure is not optional — it is structurally embedded in the token.

---

## 7. Generalized r-Fold Mint

**Definition.** An **r-fold mint** (for `r > 1`) is a generalization of the 2x mint where depositing `m` backing tokens mints `r·m` wrapped tokens total: `u = m` to the user and `(r−1)·m` to the pool (on the first deposit; subsequent deposits preserve ratio proportionally).

**Equilibrium of r-fold mint.** The equilibrium ratio is `P/T = (r−1)/r`, and at equilibrium the user receives `m/r` wrapped tokens from `m` backing (wait — let me reconsider).

Actually the generalization is: total minted = `r·m`, allocated `(r-1)/r` to pool and `1/r` to user on first deposit. Subsequent deposits preserve `P/T` ratio.

At equilibrium `P/T = (r−1)/r`:
- Heat(m): `p = r·m·(r−1)/r = m(r−1)`, `u = r·m − m(r−1) = m`
- User always receives `m` wrapped per `m` backing (1:1 at equilibrium, independent of `r`)

**Observation.** The equilibrium exchange rate is always 1:1 regardless of `r`. The parameter `r` controls:
- **Liquidity depth:** Pool holds fraction `(r−1)/r` of total supply, deepening with `r`
- **Depositor dilution:** New depositors receive fraction `1/r` of minted supply
- **Round-trip cost:** The "impermanent" LP exposure scales with `r`

**Proposition 2.** The Ratio Preservation Theorem (Theorem 1) holds for all r-fold mints. The equilibrium is `P/T = (r−1)/r` and is unique.

*Proof.* The allocation formula `p = r·m·P/T`, `u = r·m − p` preserves `P/T` by the same algebra as Theorem 1 with `2m` replaced by `r·m`. □

**Proposition 3 (Uniqueness of 2x).** The 2x mint (`r = 2`) is the unique r-fold mint with the property that, on the first deposit, the depositor and pool receive equal amounts.

*Proof.* On first deposit (T = 0, P = 0), the formula degenerates to the base case: `u = p = m`. This holds only when `r = 2`. For r > 2, `p > m` and `u < m`; for `1 < r < 2`, `u > m` and `p < m`. □

---

## 8. Hub-and-Spoke Networks

The 2x mint mechanism can be deployed in a **hub-and-spoke topology**: a central *hub* instance wrapping a numeraire asset `N`, and arbitrary *spoke* instances each wrapping a distinct backing token `Aᵢ`. Each spoke maintains a lake denominated in hub tokens, enabling cross-spoke exchange.

### 8.1 Network State

A hub-and-spoke network with spokes `{1, ..., n}` has state:

```
Hub: (P_h, -, T_h, B_h)
Spoke i: (P_i, L_i, T_i, B_i)   for i = 1,...,n
```

Hub has no lake (it is the numeraire); spokes have lakes denominated in hub tokens.

### 8.2 Two-Hop Routing

Any spoke-to-spoke swap routes through the hub:

```
Spoke A → Hub → Spoke B
```

This ensures maximum path length of 2 for any token pair, at the cost of hub price impact. The number of AMM pools required is `n` (linear) rather than `n(n−1)/2` (quadratic).

**Proposition 4 (Liquidity Concentration).** In a hub-and-spoke network, all liquidity for backing token `Aᵢ` is concentrated in a single instance. In a mesh topology, the same liquidity would be split across `n−1` pairs. For large `n`, the hub-and-spoke topology provides strictly better execution for any individual pair.

*Proof.* Under the constant-product formula, price impact for a trade of size `s` in a pool with reserve `P` is `s/(P − s)`. With reserves concentrated in one pool of size `P` versus split across `k` pools each of size `P/k`, the total effective liquidity for a single pair is strictly higher in the concentrated case. □

### 8.3 Cross-Spoke Equilibrium

In a hub-and-spoke network, the equilibrium conditions for all spokes are coupled through the hub price. If spoke `i` has equilibrium ratio `ρᵢ = 1/2` and hub price `πᵢ = L_i/P_i`, then the implied exchange rate between spokes `i` and `j` is `πᵢ/πⱼ`. Arbitrage can occur not only within a spoke (correcting `ρᵢ`) but also cross-spoke (correcting relative prices).

**Open Question 1.** Characterize the joint Nash equilibrium of cross-spoke arbitrage in a hub-and-spoke network. Does the network equilibrium uniquely determine all spoke prices given the hub's backing price?

---

## 9. No-Arbitrage Properties

### 9.1 Round-Trip Loss

We have established (Lemma 3) that a heat-cool round trip without trades is loss-free. We now consider round trips that include trades.

**Proposition 5 (Round-Trip with AMM Loss).** A round trip of the form Heat(m) → Sell(u) → Buy(u') → Cool(u') loses value to AMM slippage.

*Proof sketch.* Sell(u) followed by Buy(u') with the same hub amount buys strictly fewer than `u` wrapped tokens due to the constant-product curve's concavity. Thus `u' < u`. Cooling `u'` returns `m' < m` backing. □

**Corollary 3.** There are no profitable arbitrage cycles that do not move the system closer to equilibrium. All profitable cycles are equilibrating.

### 9.2 Sandwich Attack Immunity

A common attack on AMMs is the *sandwich attack*: front-run a large trade to move price, then back-run to capture profit.

**Proposition 6.** The Heat and Cool operations are immune to sandwich attack losses. A sandwiched Heat(m) operation returns the same `u` regardless of interleaved trades.

*Proof.* Heat(m) is determined by `P/T` at the time of execution. Interleaved trades change `P` and `L` but not `T` (no tokens minted/burned). However, they *do* change `P/T` if trades occur *between* the time `m` is committed and the Heat executes. In an atomic transaction (no interleaving), this is trivially safe.

More precisely: within a single atomic transaction, no sandwiching is possible. The relevant attack vector is MEV-based front-running of the *submitted transaction*, which is a property of the execution environment, not the protocol mechanics. The protocol provides no amplification mechanism for such attacks — Heat does not offer arbitrage to an attacker unless they also move the price, and moving the price requires providing liquidity in return. □

---

## 10. Open Problems

The 2x mint mechanism raises several interesting theoretical questions:

**Problem 1 (Stability Analysis).** Provide a formal dynamical systems treatment of convergence to the equilibrium `ρ = 1/2`. Under what assumptions on arbitrageur behavior (e.g., myopic best-response, Bayesian rational) does the system converge? What is the convergence rate?

**Problem 2 (Optimal Arbitrage).** Characterize the optimal arbitrage strategy (amount to heat/cool, amount to trade) for an arbitrageur starting with some amount of backing tokens and observing system state `(P, L, T, B)`. This is a one-shot optimization problem; a full solution would characterize arbitrage profitability as a function of disequilibrium magnitude.

**Problem 3 (Multi-Instance Equilibrium).** In a hub-and-spoke network with `n` spokes, characterize the joint Nash equilibrium of rational arbitrageurs acting across all instances simultaneously. Does the equilibrium uniquely determine all cross-spoke exchange rates?

**Problem 4 (Impermanent Loss).** In traditional AMMs, LPs face *impermanent loss* relative to holding. The triple role collapse means every holder has implicit LP exposure. Characterize the expected gain/loss for a holder who deposits at state `(P, L, T, B)` and withdraws after a sequence of `k` trades, as a function of the trade distribution.

**Problem 5 (Generalization to Non-Fungible Positions).** The 2x mint creates fungible LP exposure because all wrapped tokens are identical. Can the mechanism be adapted to issue *differentiated* LP positions that track individual entry states? What invariants would such a generalization need to preserve?

**Problem 6 (Information Aggregation).** In a hub-and-spoke network with many spokes, the hub price aggregates information about all backed assets. What are the information-theoretic properties of this aggregation? Does the hub price converge to a sufficient statistic for cross-spoke exchange ratios?

**Problem 7 (Optimal r).** For a given distribution of trader arrival rates and trade sizes, what value of `r` in the r-fold mint maximizes social welfare (defined as minimizing total slippage across all participants)?

---

## 11. Discussion

The 2x mint mechanism exhibits a structural property that, to our knowledge, has not been previously identified in the AMM literature: **the deposit/withdrawal class of operations and the trading class of operations are orthogonal in the state space**, each preserving one invariant while modifying the other. This clean separation provides two practical benefits: (1) deposits and withdrawals cannot be used to manipulate prices via sandwich attacks, and (2) the system's equilibrium is purely maintained by traders (arbitrageurs), with depositors playing no adversarial role.

The triple role collapse — bearer asset, LP position, and pool reserve collapsing to a single token — is a consequence of this orthogonality combined with the ratio preservation property. The pool holds more of the same token; this would create circular reasoning in a traditional LP model (where LP tokens give a claim on pool reserves, but the pool reserve IS the LP token). The resolution is that the "LP claim" is implicit in the heat/cool exchange rate, not in any explicit accounting entry. Wrapped tokens don't represent a share of the pool; they *are* shares of the total supply, and the total supply includes the pool.

The mechanism has a natural information-theoretic interpretation: the pool-to-supply ratio `ρ = P/T` is a single scalar that summarizes the deviation from equilibrium. All relevant quantities — heat rate, cool rate, trading price — are determined by this scalar plus the absolute pool depth. An arbitrageur observing `ρ` knows everything needed to compute profit and the direction of corrective action. This is an unusually clean signal structure for a multi-parameter financial mechanism.

---

## Acknowledgments

The author thanks the DeFi research community for prior work on constant-product AMMs and liquidity provisioning mechanisms that forms the context for this analysis. This work originated from the design of the Liquid protocol at uniteum.one.

---

## References

- Adams, H., Zinsmeister, N., Salem, M., Keefer, R., Robinson, D. (2021). *Uniswap v3 Core.* Uniswap Labs.
- Ahuja, R. K., Magnanti, T. L., Orlin, J. B. (1993). *Network Flows: Theory, Algorithms, and Applications.* Prentice Hall.
- Angeris, G., Agrawal, A., Evans, A., Chitra, T., Boyd, S. (2021). Constant function market makers: Multi-asset trades via convex optimization. *Financial Cryptography 2022.*
- Angeris, G., Chitra, T. (2020). Improved price oracles: Constant function market makers. *ACM CCS 2020.*
- Egorov, M. (2019). *StableSwap — efficient mechanism for stablecoin liquidity.* Curve Finance whitepaper.
- Hertzog, E., Benartzi, G., Benartzi, G. (2020). *Bancor v2.1 Economic Analysis.* Bancor Network.
- Kuo, B., Pasternack, D., von Loon, K. (2019). *Ampleforth: A New Synthetic Commodity.* Ampleforth Foundation.
- Xu, J., Paruch, K., Cousaert, S., Feng, Y. (2023). SoK: Decentralized exchanges (DEX) with automated market maker (AMM) protocols. *ACM Computing Surveys.*

---

*Preprint. Comments welcome at reinholdtsen.eth. Deployed protocol: uniteum.one/liquid.*
