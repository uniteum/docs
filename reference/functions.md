---
title: Functions
description: >-
  Contract function reference for Uniteum:
  signatures, parameters, and usage.

# Navigation
nav_order: 2
parent: Reference
has_children: false

# Taxonomy
categories:
  - development

# Metadata
last_updated: 2024-12-11
version: "0.1"
status: complete
---

# Functions

Complete reference for Uniteum contract functions. All functions are from the IUnit interface and Unit implementation unless otherwise specified.

{: .note }
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

---

## Unit Creation

### Creating Symbolic Units

#### `multiply(string expression) → IUnit unit`

Create a symbolic unit (or compound unit) from a string expression. If the unit already exists, returns its address without creating a new one.

**Parameters:**
- `expression` — Unit symbol or expression
  - Base unit: `"meter"`, `"USD"`, `"kg"`
  - Compound: `"kg*m/s^2"`, `"USD/BTC"`
  - Rational powers: `"foo^2\3"` (foo to the 2/3 power)

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
- `\` — divide in exponents (e.g., `^2\3` = ^(2/3))

**Emits:** `UnitCreate(IUnit unit, IERC20 anchor, bytes32 hash, string symbol)` (if new)

**Example:**
```solidity
IUnit one = IUnit({% include uniteum_address.html %});
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

**Symbol Format:** `$0xTokenAddress`

**Example:**
```solidity
IERC20 usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
IUnit anchoredUSDT = one().anchored(usdt);
// symbol: "$0xdAC17F958D2ee523a2206206994597C13D831ec7"
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

{% assign current_uniteum = site.data.contracts.uniteum[site.data.contracts.current.uniteum] -%}
**Contract:** [`{{ current_uniteum.mainnet }}`](https://etherscan.io/address/{{ current_uniteum.mainnet }}#code) ({{ current_uniteum.name }})

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
- Zero address for symbolic units

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
- `symbol` — Format: `$0x...`

---

## Migration Functions

### `migrate(uint256 units)`

Migrate v0.0 "1" tokens to v0.1 "1" tokens.

**Parameters:**
- `units` — Amount of v0.0 tokens to migrate

**Requirements:**
- Only callable on "1" token
- Must approve v0.1 contract to spend v0.0 tokens

**Effect:**
- v0.0 tokens transferred to v0.1 contract
- v0.1 tokens minted to caller
- Total circulating supply conserved

{% assign genesis_uniteum = site.data.contracts.uniteum.v0_0 -%}
**Example:**
```solidity
IERC20 v0 = IERC20({{ genesis_uniteum.mainnet }});
IUnit current = IUnit({{ current_uniteum.mainnet }});

v0.approve(address(current), 1000e18);
current.migrate(1000e18);
```

---

### `unmigrate(uint256 units)`

Reverse migration—convert v0.1 "1" back to v0.0 "1".

**Parameters:**
- `units` — Amount of v0.1 tokens to unmigrate

**Requirements:**
- Only callable on "1" token

**Effect:**
- v0.1 tokens burned from caller
- v0.0 tokens transferred back to caller

---

## Constants & Immutables

### `ONE_SYMBOL`

Constant string for "1" token symbol.

**Value:** `"1"`

---

### `NAME_PREFIX`

Prefix for all unit names.

**Value:** Version-specific (e.g., `"Uniteum 0.3 "` for current version)

**Example:** Unit "meter" has name "Uniteum 0.3 meter" (on current version)

---

### `ONE_MINTED`

Immutable value tracking the total original "1" supply minted in genesis.

**Type:** `uint256`

**Note:** Total "1" supply will never exceed this value

---

### `UPSTREAM_ONE()`

Address of v0.0 "1" token accepted for migration.

**Returns:** ERC-20 address of upstream "1"

**Value:** [`0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4`](https://etherscan.io/address/0xC833f0B7cd7FC479DbbF6581EB4eEFc396Cf39E4#code) (v0.0)

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

## Discount Kiosk Functions

The Discount Kiosk is a separate contract for selling v0.0 "1" tokens.

**Contract:** [`0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9`](https://etherscan.io/address/0x55816c3e5d999e2f45ce0146ffd89b2e78a56dc9#code)

### `buy() → (uint256 q, bool soldOut)` {payable}

Purchase "1" tokens by sending ETH. Price increases linearly as inventory depletes to zero.

**Payment:** ETH sent with transaction (`msg.value`)

**Returns:**
- `q` — Quantity of "1" tokens purchased
- `soldOut` — True if kiosk depleted

**Pricing:** `price(x) = listPrice × (1 - x / capacity)`

**Note:** No refunds if kiosk runs out during your purchase

**Emits:** `KioskBuy(address buyer, uint256 value, uint256 quantity)`

---

### `quote(uint256 v) → (uint256 q, bool soldOut)`

Calculate how many "1" tokens can be purchased for a given ETH amount.

**Parameters:**
- `v` — ETH amount (in wei)

**Returns:**
- `q` — Quantity of tokens purchasable
- `soldOut` — Whether this would deplete inventory

**Use:** Preview purchase before executing

---

### `inventory() → uint256`

Get current token inventory in kiosk.

**Returns:** Available "1" tokens

---

### `balance() → uint256`

Get ETH balance held by kiosk.

**Returns:** ETH in wei

---

### `reclaim(uint256 quantity)`

Owner-only: withdraw token inventory from kiosk.

**Parameters:**
- `quantity` — Tokens to withdraw

**Access:** Only kiosk owner

---

### `collect(uint256 value)`

Owner-only: withdraw ETH from kiosk.

**Parameters:**
- `value` — ETH to withdraw (wei)

**Access:** Only kiosk owner

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
