# Design: `set` / `iset` — immutable content-addressed address sets

**Date:** 2026-07-08
**Author:** design session (Paul Reinholdtsen)
**Status:** approved, pre-implementation

> Location note: this spec temporarily lives in the `docs` repo under `.meta/specs/`.
> It describes two **new sibling repos** (`uniteum/set`, `uniteum/iset`) that do not
> exist yet. Once `uniteum/set` is created, this document should move into it
> (e.g. `set/docs/design.md`) as the repo's canonical design record.

## Summary

A new Bitsy contract family of **immutable, content-addressed, canonically-ordered
sets**. Each distinct set of elements lives at exactly one address, derived
deterministically from the set's contents — no address mining, no `variant` knob.
The first (and only v1) member is **`AddressSet`**, a set of `address` elements.

The family rides the existing Bitsy machinery: `AddressSet` inherits
`proto/Prototype.sol`, so it is simultaneously the EIP-1167 implementation and the
CREATE2 factory. All the design work is in the *set semantics* layered on top:
canonicalization, the query surface, set algebra (union / intersection /
difference), and the unification of the empty set with the prototype itself.

This follows the ecosystem's split convention: an implementation repo `set` (code
under `src/`) and a paired interface repo `iset` (`.sol` files at repo root),
consumed downstream as git submodules under `lib/` wired through `remappings.txt`.

## Motivation (why)

The ecosystem already has immutable, deterministic reference data (Locale). A
content-addressed **set** is the natural companion primitive: a permanent,
permissionless, governance-free container whose *address is its identity*. Because
the address is a pure function of the contents, two parties who construct the same
set — anywhere, on any chain — arrive at the same address without coordination.
Set algebra (union/intersection/difference) then composes these canonical objects
into new canonical objects, each again addressable by content.

## Non-goals

- No mutable sets. Sets are immutable once created; "modifying" a set means
  computing a new set (via algebra) that lives at a different address.
- No address mining / vanity `variant` for clones. Exactly one address per set.
- No element types beyond `address` in v1. The repo and interfaces are structured
  so `UintSet` / `Bytes32Set` can be added later, but they are out of scope now.
- No off-chain dependencies. Usable directly from a block explorer.

## Architecture

`AddressSet` inherits `proto/Prototype.sol` (the shared Bitsy base). The base
provides the content-addressed clone flow verbatim:

```solidity
address public immutable proto = address(this);

function made(bytes32 argshash, uint256 variant) public view returns (bool exists, address home, bytes32 salt) {
    salt = argshash ^ bytes32(variant);
    home = Clones.predictDeterministicAddress(proto, salt, proto);
    exists = home.code.length > 0;
}

function make(bytes calldata args, uint256 variant) external returns (bool exists, address home, bytes32 salt) {
    if (address(this) == proto) {
        (exists, home, salt) = made(args, variant);
        if (!exists) {
            home = Clones.cloneDeterministic(proto, salt, 0);
            IPrototype(home).zzInit(args, variant);
            emit Made(home, salt, variant);
        }
    } else {
        (exists, home, salt) = IPrototype(proto).make(args, variant);
    }
}

function zzInit(bytes calldata args, uint256 variant) external virtual; // overridden, onlyProto
```

There is no meaningful alternative architecture that stays Bitsy; the design below
is the set-specific layer over this base.

## The addressing invariant

For any address set *S*, there is **exactly one** `AddressSet` instance:

- If *S* is **non-empty**: a clone at
  `predictDeterministicAddress(proto, keccak256(abi.encode(canonical(S))), proto)`,
  where `canonical(S)` is the **strictly-ascending, deduplicated** `address[]`.
  The base `variant` is fixed to `0`; it is never exposed.
- If *S* is **empty**: the **prototype itself** (see "Empty set = prototype").

`canonical(S)` uses a total order on `address` (ascending by `uint160` value).
"Strictly ascending" simultaneously guarantees *sorted* and *no duplicates*.

### Enforcement (two layers)

1. **`make(address[] input)` canonicalizes.** One O(n) scan checks whether `input`
   is already strictly ascending. If so, it is used as-is (fast path). Otherwise it
   is sorted in memory and deduplicated. The canonical array is then ABI-encoded and
   forwarded to the base as `this.make(abi.encode(canon), 0)`.

2. **`zzInit(args, variant)` verifies** (guarded `onlyProto`):
   - `require(variant == 0)` — closes any mining attempt via a direct base call.
   - decode `address[] canon`, then `require` it is **strictly ascending** — closes
     any non-canonical clone via a direct base call.
   - `require(canon.length > 0)` — no empty-set clone can ever be deployed (see
     below).

Because both layers enforce canonicality, even a direct call to the raw base
`make(bytes, variant)` cannot create a non-canonical clone, a duplicate-address
clone for the same set, or an empty-set clone.

### Canonicalization algorithm

- Fast path: single pass; if `input[i] < input[i+1]` holds for all `i`, `canon = input`.
- Slow path: in-memory sort (insertion sort is adequate for the small sizes these
  reference sets typically hold; can be swapped for quicksort if a use case needs
  large sets), followed by a single dedupe pass.
- Silent dedupe: `{A, A, B}` collapses to `{A, B}`. Any bag of addresses maps to
  its underlying set.

## Empty set = prototype

The prototype (deployed once via Nick at a mined vanity address) has empty storage,
so it *already* behaves as the empty set for every query: `length() == 0`,
`values() == []`, `contains(x) == false` for all `x`, `at(0)` reverts.

Therefore:

- `make(address[] input)` and `made(address[] input)`: after canonicalization, if
  `canon.length == 0`, return `(true, proto)` **without deploying**.
- Any set-algebra operation whose result is empty routes through `make([])` and thus
  returns `proto`.
- `zzInit` reverts on an empty array, so the empty set is **uniquely** the
  prototype. The content-address slot for `keccak256(abi.encode([]))` is
  intentionally left vacant.

The empty set's canonical address is the prototype's vanity address — the
well-known root of the family, and the identity element for `union`.

## Storage

Written once in `zzInit`, on clones only (the prototype's storage stays empty):

```solidity
address[] private _values;                 // strictly ascending
mapping(address => uint256) private _indexPlus1; // index + 1; 0 = absent
```

The mapping buys O(1) `contains` and `indexOf`, paid once at creation (~20k gas per
element). The sorted array drives the O(n+m) merges in set algebra.

## Interface (`iset/IAddressSet.sol`)

`IAddressSet is IPrototype` (so consumers inherit `proto()`, the base
`make`/`made`, and the `Made` event). `iset` depends on `iproto` (submodule).

### Queries (view, on a set instance)

```solidity
function values() external view returns (address[] memory); // sorted ascending
function length() external view returns (uint256);
function at(uint256 index) external view returns (address);  // reverts if out of range
function contains(address element) external view returns (bool);            // O(1)
function indexOf(address element) external view returns (bool found, uint256 index); // O(1)
```

### Set algebra (on a set instance)

```solidity
function union(address other)        external returns (bool exists, address set);
function intersection(address other) external returns (bool exists, address set);
function difference(address other)   external returns (bool exists, address set); // this \ other
```

Each reads its own sorted `_values` and `other`'s via `IAddressSet(other).values()`,
performs an O(n+m) merge that emits a strictly-ascending result directly, then calls
`IAddressSet(proto).make(result)` to obtain the result set (fast path applies, since
the merge output is already canonical; an empty result returns `proto`).
`union` and `intersection` yield the same address regardless of operand order;
`difference` does not.

### Maker surface (typed, on the prototype)

```solidity
function make(address[] calldata elements) external returns (bool exists, address set);
function made(address[] calldata elements) external view returns (bool exists, address set); // predictor, no deploy
function encode(address[] calldata elements) external pure returns (bytes memory); // canonical args blob
```

`make` and `made` are **exact signature mirrors**: identical parameters
(`address[] elements`) and identical return tuple (`bool exists, address set`),
differing only in mutability — `make` deploys (or returns the existing instance),
`made` predicts without deploying. **Neither exposes `variant`.** `variant` is an
internal detail of the base call, always `0`, and never appears in the typed API.
Internally, `make` calls `this.make(abi.encode(canon), 0)` and `made` calls the
base `made(abi.encode(canon), 0)`; both special-case the empty canonical set to
return `(true, proto)`.

`encode` is public (mirrors Locale) so off-chain tooling and other contracts can
reproduce the exact canonical byte string that determines the salt/address. It
canonicalizes then `abi.encode`s.

Plus the inherited base surface (`proto`, `make(bytes,uint256)`, `made(...)`,
`Made` event) and `string public constant version = "1.0.0"`.

## Repos, dependencies, conventions

### `iset` (interface repo)

- `.sol` files at repo root: `IAddressSet.sol`.
- Dependency: `iproto` (submodule) — `IAddressSet is IPrototype`.
- MIT, `pragma solidity ^0.8.34`.

### `set` (implementation repo)

- `src/AddressSet.sol`.
- Submodule deps under `lib/`, wired via `remappings.txt`: `crucible`, `proto`,
  `iproto`, `clones`, `iset`, `forge-std`.
- MIT, `pragma solidity ^0.8.34`. `foundry.toml` pins `solc = "0.8.34"`,
  `evm_version = "cancun"`, `via_ir = true`, `bytecode_hash = "none"`,
  `cbor_metadata = false` (deterministic bytecode). `create2_deployer` = Nick
  (`0x4e59b44847b379578588920cA78FbF26c0B4956C`).
- `@author Paul Reinholdtsen (reinholdtsen.eth)`.

### Deployment (`io/AddressSet/AddressSet.sh`)

`AddressSet` is a **prototype**: deployed once via Nick with a mined vanity salt.
The script uses `proto_predict` (per the `predict` skill / `crucible` `proto.sh`).
Clones are **not** pre-deployed — callers create them on demand via `make()`.
Follow `crucible`'s canonical "new repo setup" flow (README + any `bitsify`
scaffolding skill) when creating the repos.

## Testing (Foundry, in `set`)

- **Canonicalization:** unsorted input and duplicate-bearing input both resolve to
  the identical address as the sorted, deduped set; fast path vs slow path produce
  identical results.
- **Empty set = prototype:** `make([])` / `made([])` return `(true, proto)` and
  deploy nothing; the prototype answers `length()==0`, `values()==[]`,
  `contains(x)==false`; a direct base `make(abi.encode(new address[](0)), 0)`
  reverts.
- **Content addressing & idempotence:** the same set always maps to the same
  address; a second `make` returns the existing clone (`exists == true`), deploys
  nothing.
- **No mining:** direct base `make` with `variant != 0` reverts; direct base `make`
  with non-strictly-ascending args reverts.
- **Queries:** `contains` / `indexOf` correctness (present and absent elements);
  `at` in-range and out-of-range; `length`; `values` ordering.
- **Set algebra:** `union` / `intersection` / `difference` correctness, including
  empty results (→ `proto`), self-operations (`A ∪ A == A`, `A ∩ A == A`,
  `A \ A == ∅`), operand-order independence of `union`/`intersection` addresses,
  and `difference` asymmetry.

## Open implementation questions (resolve during planning)

- Exact in-memory sort implementation and whether to bound set size.
- Whether `iset` also predeclares placeholder interfaces for future `UintSet` /
  `Bytes32Set`, or defers them entirely.
- The mined vanity target for the `AddressSet` prototype address (saltminer step).
