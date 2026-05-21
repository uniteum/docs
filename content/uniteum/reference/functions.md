---
title: Functions
description: >-
  Contract function reference for Uniteum:
  signatures, parameters, and usage.

# Navigation

# Taxonomy

# Metadata
weight: 2
---

# Functions

Complete reference for Uniteum contract functions. All functions are from the IUnit interface and Unit implementation unless otherwise specified.


> All Unit tokens are ERC-20 compliant and include standard functions like `transfer()`, `approve()`, `balanceOf()`, etc.

---

## Core Operations

### Forge Operations

The forge operation is the primary mechanism for minting, burning, and swapping units while maintaining constant-product invariants.

#### `forge(int256 du, int256 dv) → int256 dw`

Mint/burn combinations of a unit (U), its reciprocal (1/U), and "1" to maintain the constant-product invariant.

**Parameters:**
- `du` — Signed change of caller's unit balance
  - Positive: mint units to caller
  - Negative: burn units from caller
- `dv` — Signed change of caller's reciprocal balance (1/U)
  - Positive: mint reciprocal to caller
  - Negative: burn reciprocal from caller

**Returns:**
- `dw` — Signed change of caller's "1" balance (calculated to preserve invariant)

**Requirements:**
- Cannot be called on the "1" token itself
- For anchored units: caller must approve token transfers
- Reverts with `NegativeSupply` if operation would create negative supply

**Emits:** `Forge(address holder, IUnit unit, int256 du, int256 dv, int256 dw)`

**Gas:** Uses reentrancy guard (transient storage)

**Example:**
```solidity
// Mint 100 meter tokens, burn 50 1/meter, calculate "1" change
IUnit meter = one().multiply("meter");
int256 dw = meter.forge(100e18, -50e18);
```

---

#### `forge(IUnit V, int256 du, int256 dv) → (IUnit W, int256 dw)`

Forge operation for compound units or arbitrary unit pairs. Works on triads (U, V, U×V) or (U, 1/U, 1).

**Parameters:**
- `V` — The other unit in the pair
- `du` — Signed change of this unit's balance
- `dv` — Signed change of unit V's balance

**Returns:**
- `W` — Product unit (U×V) or "1" if V is this unit's reciprocal
- `dw` — Signed change of product unit W's balance

**Important Behavior:**
- **Reciprocal forging** (V = 1/U): Mints/burns tokens, no transfers
- **Compound forging** (V ≠ 1/U): Mints/burns W AND transfers U and V custodially to/from caller

**Requirements:**
- Cannot use duplicate units (U must not equal V)
- For compound forging: constituent units are transferred to/from W's address

**Emits:** `Forge(address holder, IUnit unit, int256 du, int256 dv, int256 dw)`

**Example:**
```solidity
// Forge compound unit meter/second
IUnit meter = one().multiply("meter");
IUnit second = one().multiply("second");
(IUnit meterPerSecond, int256 dw) = meter.forge(second, 100e18, -50e18);
```

---

### Quote Functions (View)

Preview forge operations without executing them.

#### `forgeQuote(int256 du, int256 dv) → int256 dw`

Calculate the change in "1" balance required for a forge operation.

**Parameters:**
- `du` — Signed change of unit balance
- `dv` — Signed change of reciprocal balance

**Returns:**
- `dw` — Signed change of "1" balance needed to maintain invariant

**Use:** Preview forge costs before execution

**Floating-side scaling:** The returned `dw` is scaled by the number of **non-anchored** sides in the (U, 1/U) pair:
- both sides floating → `dw` is doubled (×2)
- exactly one side anchored → `dw` is unscaled (×1)
- both sides anchored → `dw` is zero (×0), since the anchor tokens themselves carry all of the value movement

This mirrors the source: `if (address(anchor) == address(0) && address(reciprocal.anchor()) == address(0)) dw *= 2;` in `Unit.sol`'s `forgeQuote(int256,int256)`.

---

#### `forgeQuote(IUnit V, int256 du, int256 dv) → (IUnit W, int256 dw)`

Calculate the product unit and balance change for a compound forge operation.

**Parameters:**
- `V` — The other unit
- `du` — Signed change of this unit
- `dv` — Signed change of unit V

**Returns:**
- `W` — Product unit address
- `dw` — Signed change of W's balance

**Floating-side scaling:** As with the reciprocal overload, the returned `dw` is multiplied by a `floatingCount` of 0, 1, or 2 — one count for each side of the pair whose `anchor()` is the zero address. Both floating → ×2; one anchored → ×1; both anchored → ×0. See `Unit.sol`'s `forgeQuote(IUnit,int256,int256)` for the exact expression.

---

## Unit Creation

### Creating Floating Units

#### `multiply(string expression) → IUnit unit`

Create a floating unit (or compound unit) from a string expression. If the unit already exists, returns its address without creating a new one.

**Parameters:**
- `expression` — Unit symbol or expression
  - Base unit: `"meter"`, `"USD"`, `"kg"`
  - Compound: `"kg*m/s^2"`, `"USD/BTC"`
  - Rational powers: `"foo^2:3"` (foo to the 2/3 power)

**Returns:**
- `unit` — Address of created or existing unit

**Symbol Rules:**
- Max 30 characters
- Allowed: `a-z`, `A-Z`, `0-9`, `_`, `-`, `.`
- Case-sensitive

**Operators:**
- `*` — multiply units
- `/` — divide units
- `^` — power
- `:` — divide in exponents (e.g., `^2:3` = ^(2/3))

**Emits:** `UnitCreate(IUnit unit, IERC20 anchor, bytes32 hash, string symbol)` (if new)

**Example:**
```solidity
IUnit one = IUnit({{< uniteum_address >}});
IUnit meter = one.multiply("meter");
IUnit force = one.multiply("kg*m/s^2");
```

---

#### `multiply(IUnit multiplier) → IUnit product`

Create a compound unit by multiplying this unit with another unit.

**Parameters:**
- `multiplier` — Unit to multiply with

**Returns:**
- `product` — The compound unit U×multiplier

**Example:**
```solidity
IUnit meter = one().multiply("meter");
IUnit second = one().multiply("second");
IUnit velocity = meter.multiply(second.reciprocal());
// velocity.symbol() == "m/s"
```

---

### Creating Anchored Units

#### `anchored(IERC20 token) → IUnit unit`

Create an anchored unit backed 1:1 by an external ERC-20 token. The Unit contract holds the backing tokens custodially.

**Parameters:**
- `token` — Address of ERC-20 token to anchor

**Returns:**
- `unit` — Address of anchored unit

**Symbol Format:** `0xTokenAddress`

**Example:**
```solidity
IERC20 usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
IUnit anchoredUSDT = one().anchored(usdt);
// symbol: "0xdAC17F958D2ee523a2206206994597C13D831ec7"
```

**Important:**
- Requires token approval for minting
- Tokens held by Unit contract
- Custodial backing

---

## Query Functions

### Invariant Queries

#### `invariant() → (uint256 u, uint256 v, uint256 w)`

Get current supplies for this unit and its reciprocal, plus their geometric mean.

**Returns:**
- `u` — Total supply of this unit
- `v` — Total supply of reciprocal unit
- `w` — sqrt(u × v) — the invariant

**Formula:** `sqrt(u × v) = w`

**Price Calculation:**
- Price of U = `v / u`
- Price of 1/U = `u / v`
- Equal supplies (u = v) → both trade at parity

---

#### `invariant(uint256 u, uint256 v) → uint256 w`

Calculate invariant for given supplies (pure function).

**Parameters:**
- `u` — Supply of unit
- `v` — Supply of reciprocal

**Returns:**
- `w` — sqrt(u × v)

---

#### `invariant(IUnit V) → (IUnit W, uint256 u, uint256 v, uint256 w)`

Get invariant for this unit paired with another unit V.

**Parameters:**
- `V` — Pair unit

**Returns:**
- `W` — Product unit (this × V)
- `u` — Supply of this unit held by W
- `v` — Supply of V held by W
- `w` — sqrt(u × v)

**Behavior:**
- If V is reciprocal: returns "1" as W
- Otherwise: returns compound unit U×V

---

### Unit Information

#### `one() → IUnit`

Get the "1" token address (universal liquidity token).

**Returns:** Address of "1" token

**Contract:** [`{{< val "contracts.uniteum.address" >}}`]({{< escan >}}/address/{{< val "contracts.uniteum.address" >}}#code) ({{< val "contracts.uniteum.name" >}})

---

#### `reciprocal() → IUnit`

Get this unit's reciprocal unit.

**Returns:** Address of 1/U

**Example:**
```solidity
IUnit meter = one().multiply("meter");
IUnit perMeter = meter.reciprocal();
// perMeter.symbol() == "1/m"
```

---

#### `anchor() → IERC20`

Get the backing token for anchored units.

**Returns:**
- ERC-20 address for anchored units
- Zero address for floating units

**Use:** Check if unit is anchored

---

### Prediction Functions

#### `product(string expression) → (IUnit unit, string symbol)`

Predict the address and canonical symbol for a unit expression without creating it.

**Parameters:**
- `expression` — Unit expression

**Returns:**
- `unit` — Predicted address
- `symbol` — Canonical form of expression

**Use:** Check if unit exists before creating

---

#### `product(IUnit multiplier) → (IUnit unit, string symbol)`

Predict the product unit address and symbol.

**Parameters:**
- `multiplier` — Unit to multiply with

**Returns:**
- `unit` — Product unit address
- `symbol` — Canonical symbol

---

#### `anchoredPredict(IERC20 token) → (IUnit unit, string symbol)`

Predict the address and symbol for an anchored unit.

**Parameters:**
- `token` — Token to anchor

**Returns:**
- `unit` — Predicted anchored unit address
- `symbol` — Anchored symbol format

---

#### `anchoredSymbol(IERC20 token) → string symbol`

Get the symbol format for an anchored unit (pure function).

**Parameters:**
- `token` — Token address

**Returns:**
- `symbol` — Format: `0x...`

---

## Migration Functions

### `migrate(uint256 units)`

Migrate v0.0 "1" tokens to current version "1" tokens.

**Parameters:**
- `units` — Amount of v0.0 tokens to migrate

**Requirements:**
- Only callable on "1" token
- Must approve current version contract to spend v0.0 tokens

**Effect:**
- v0.0 tokens transferred to current version contract
- current version tokens minted to caller
- Total circulating supply conserved

**Example:**
```solidity
IERC20 v0 = IERC20({{< val "contracts.genesis.address" >}});
IUnit current = IUnit({{< val "contracts.uniteum.address" >}});

v0.approve(address(current), 1000e18);
current.migrate(1000e18);
```

---

### `unmigrate(uint256 units)`

Reverse migration—convert current version "1" back to v0.0 "1".

**Parameters:**
- `units` — Amount of current version tokens to unmigrate

**Requirements:**
- Only callable on "1" token

**Effect:**
- current version tokens burned from caller
- v0.0 tokens transferred back to caller

---

## Constants & Immutables

### `ONE_SYMBOL`

Constant string for "1" token symbol.

**Value:** `"1"`

---

### `NAME_PREFIX`

Prefix for all unit names.

**Value:** Version-specific (e.g., `"{{< val "contracts.uniteum.name" >}} "`)

**Example:** Unit "meter" has name `{{< val "contracts.uniteum.name" >}} meter`

---

### `ONE_MINTED`

Immutable `uint256` declared on `Unit.sol`. On deployed `Unit` and its clones this immutable is **never assigned**, so it reads back as `0` — it is **not** an enforced supply ceiling.

**Type:** `uint256`

**Value:** `0` on the deployed Uniteum "1" contract and all of its Unit clones (the immutable is declared but not set in the constructor).

**Note:** The 1 billion figure sometimes cited as a ceiling is the **fixed supply of the separate genesis "1" token** ([`{{< val "contracts.genesis.address" >}}`]({{< escan >}}/address/{{< val "contracts.genesis.address" >}}#code)), not a value enforced by `ONE_MINTED`. Total current "1" supply is bounded indirectly by how much genesis "1" has been migrated in via {{< val "contracts.uniteum.name" >}}'s `migrate()`.

---

### `UPSTREAM()`

Address of v0.0 "1" token accepted for migration. Declared on `IMigratable` and implemented as the immutable `UPSTREAM` on `Unit`.

**Returns:** ERC-20 address of upstream "1"

**Value:** [`{{< val "contracts.genesis.address" >}}`]({{< escan >}}/address/{{< val "contracts.genesis.address" >}}#code) — the genesis "1" token (currently `0x7D5B1349157335aEEB929080a51003B529758830`).

---

## Events

### `UnitCreate`

Emitted when a new unit is created.

**Parameters:**
- `unit` (indexed) — Address of created unit
- `anchor` (indexed) — Backing token (or zero address)
- `hash` (indexed) — Hash used for CREATE2 address derivation
- `symbol` — Canonical symbol string

---

### `Forge`

Emitted when a forge operation completes.

**Parameters:**
- `holder` (indexed) — Address whose balances changed
- `unit` (indexed) — Unit on which forge was called
- `du` — Signed change in unit balance
- `dv` — Signed change in reciprocal/pair balance
- `dw` — Signed change in "1" or product unit balance

---

### `Migrate`

Emitted when v0.0 "1" tokens are migrated into the current "1" token.

**Parameters:**
- `user` (indexed) — Address that migrated tokens
- `amount` — Amount of tokens migrated

**Note:** `migrate()` also emits `Forge` (the underlying `__forge` mints the new "1" supply to the caller). See `IUnit.sol:304-311` and `Unit.sol:391,399`.

---

### `Unmigrate`

Emitted when current "1" tokens are unmigrated back to v0.0 "1".

**Parameters:**
- `user` (indexed) — Address that unmigrated tokens
- `amount` — Amount of tokens unmigrated

**Note:** `unmigrate()` also emits `Forge` (the underlying `__forge` burns the current "1" supply).

> The `Migrated` / `Unmigrated` events declared in `IMigratable.sol` are not emitted by `Unit.sol` — only `Migrate` / `Unmigrate` (above) are emitted. The `IMigratable` events are dead code in this implementation.

---

## Errors

### `DuplicateUnits()`

Reverted when forge is called with the same unit for both parameters.

**Trigger:** `forge(U, U, du, dv)` where U == V

---

### `FunctionCalledOnOne()`

Reverted when a function that must not be called on "1" is called on "1".

**Example:** `one().forge(...)` — forge doesn't work on "1" itself

---

### `FunctionNotCalledOnOne()`

Reverted when a function that must be called on "1" is called on another unit.

**Example:** `meter.migrate(...)` — only "1" can migrate

---

### `NegativeSupply(IUnit unit, int256 supply)`

Reverted when a forge operation would create negative token supply.

**Parameters:**
- `unit` — The unit that would have negative supply
- `supply` — The calculated negative value

**Cause:** Attempting to burn more tokens than exist

---

### `ReentryForbidden()`

Reverted when reentrancy is attempted during a forge operation.

**Protection:** Uses EIP-1153 transient storage for gas-efficient reentrancy guards

---

## ERC-20 Standard Functions

All Unit tokens implement full ERC-20:

### Transfer Functions
- `transfer(address to, uint256 amount) → bool`
- `transferFrom(address from, address to, uint256 amount) → bool`

### Approval Functions
- `approve(address spender, uint256 amount) → bool`
- `allowance(address owner, address spender) → uint256`

### Query Functions
- `balanceOf(address account) → uint256`
- `totalSupply() → uint256`

### Metadata Functions
- `name() → string`
- `symbol() → string`
- `decimals() → uint8` (always 18)

---

## See Also

- [Contracts Reference](contracts.md) — Deployment addresses
- [Forge Guide](../guides/forging.md) — Step-by-step forge operations
- [Creating Units](../guides/creating-units.md) — How to create units
- [IUnit.sol](https://github.com/uniteum/uniteum/blob/main/src/IUnit.sol) — Full interface source
