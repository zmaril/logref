---
message: "smallint out of range"
slug: smallint-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/contrib/btree_gist/btree_int2.c:106"
  - "postgres/src/backend/utils/adt/int.c:920"
  - "postgres/src/backend/utils/adt/int.c:942"
  - "postgres/src/backend/utils/adt/int.c:956"
  - "postgres/src/backend/utils/adt/int.c:970"
  - "postgres/src/backend/utils/adt/int.c:1002"
  - "postgres/src/backend/utils/adt/int.c:1241"
reproduced: true
---

# `smallint out of range`

**Severity:** ERROR · SQLSTATE `22003` (ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE)

## What it means

A value did not fit in the `smallint` (`int2`) type. Postgres stores `smallint` as a signed 16-bit integer, so the only values it can hold run from -32768 to 32767. Any conversion, cast, or arithmetic result outside that window is rejected rather than silently wrapped around.

## When it happens

Casting or coercing a number to `smallint` when it is too large or too small, or when `smallint` arithmetic overflows — addition, subtraction, multiplication, negation, or `abs()` of the most-negative value. It also fires when a query parameter or a column default lands outside the range.

## How to fix

Widen the column or expression to a type with more headroom: `integer` (±2.1 billion) or `bigint` (±9.2 quintillion). If the value genuinely should fit, clamp or validate it in the application before it reaches the database. When the overflow is in intermediate arithmetic, cast the operands up first — `a::int + b::int` — so the sum is computed in the wider type. Changing a column type is `ALTER TABLE t ALTER COLUMN c TYPE integer`.

## Example

*Reproduced* — Exercised by the type-range reproducer scenario (`03_types_range_cast.sql`).

```sql
SELECT 32768::int2;
```

Produces:

```text
ERROR:  smallint out of range
```

## Source

This message text is emitted from 7 call sites:

- [`postgres/contrib/btree_gist/btree_int2.c:106`](https://github.com/postgres/postgres/blob/master/contrib/btree_gist/btree_int2.c#L106) — ERROR
- [`postgres/src/backend/utils/adt/int.c:920`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L920) — ERROR
- [`postgres/src/backend/utils/adt/int.c:942`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L942) — ERROR
- [`postgres/src/backend/utils/adt/int.c:956`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L956) — ERROR
- [`postgres/src/backend/utils/adt/int.c:970`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L970) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1002`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1002) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1241`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1241) — ERROR

## SQLSTATE

- `22003` — **ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE**. Class 22 (Data Exception).

## Related

- [integer out of range](./integer-out-of-range.md)
- [bigint out of range](./bigint-out-of-range.md)
- [division by zero](./division-by-zero.md)
