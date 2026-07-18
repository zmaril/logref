---
message: "integer out of range"
slug: integer-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/contrib/btree_gist/btree_int4.c:104"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:166"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:248"
  - "postgres/src/backend/utils/adt/bytea.c:175"
  - "postgres/src/backend/utils/adt/float.c:4325"
  - "postgres/src/backend/utils/adt/float.c:4365"
  - "postgres/src/backend/utils/adt/int.c:805"
  - "postgres/src/backend/utils/adt/int.c:827"
  - "postgres/src/backend/utils/adt/int.c:841"
  - "postgres/src/backend/utils/adt/int.c:855"
  - "postgres/src/backend/utils/adt/int.c:886"
  - "postgres/src/backend/utils/adt/int.c:907"
  - "postgres/src/backend/utils/adt/int.c:1024"
  - "postgres/src/backend/utils/adt/int.c:1038"
  - "postgres/src/backend/utils/adt/int.c:1052"
  - "postgres/src/backend/utils/adt/int.c:1085"
  - "postgres/src/backend/utils/adt/int.c:1099"
  - "postgres/src/backend/utils/adt/int.c:1113"
  - "postgres/src/backend/utils/adt/int.c:1144"
  - "postgres/src/backend/utils/adt/int.c:1227"
  - "postgres/src/backend/utils/adt/int.c:1291"
  - "postgres/src/backend/utils/adt/int.c:1359"
  - "postgres/src/backend/utils/adt/int.c:1365"
  - "postgres/src/backend/utils/adt/numeric.c:2025"
  - "postgres/src/backend/utils/adt/varbit.c:1193"
  - "postgres/src/backend/utils/adt/varlena.c:873"
reproduced: false
---

# `integer out of range`

**Severity:** ERROR · SQLSTATE `22003` (ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE)

## What it means

A value did not fit in the `integer` (`int4`) type — a signed 32-bit integer holding -2147483648 to 2147483647. The value overflowed that range and Postgres refused to truncate it.

## When it happens

Casting a larger number down to `integer`, or `integer` arithmetic that overflows (a running sum, a product, `n * n`), or passing an out-of-range literal to a function that takes an `integer` argument such as a sequence increment or an array subscript count.

## How to fix

Use `bigint` for the column or the expression, or compute the arithmetic in `bigint` by casting an operand: `SELECT a::bigint * b`. If the value is a genuine identifier that keeps growing, migrate the column to `bigint` before it reaches the ceiling — this is the classic reason to prefer `bigint` primary keys over `integer` ones.

## Example

*Illustrative* — A 32-bit cast that overflows.

```sql
SELECT 2147483648::int4;
```

Produces:

```text
ERROR:  integer out of range
```

## Source

This message text is emitted from 26 call sites:

- [`postgres/contrib/btree_gist/btree_int4.c:104`](https://github.com/postgres/postgres/blob/master/contrib/btree_gist/btree_int4.c#L104) — ERROR
- [`postgres/src/backend/utils/adt/array_userfuncs.c:166`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/array_userfuncs.c#L166) — ERROR
- [`postgres/src/backend/utils/adt/array_userfuncs.c:248`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/array_userfuncs.c#L248) — ERROR
- [`postgres/src/backend/utils/adt/bytea.c:175`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/bytea.c#L175) — ERROR
- [`postgres/src/backend/utils/adt/float.c:4325`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/float.c#L4325) — ERROR
- [`postgres/src/backend/utils/adt/float.c:4365`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/float.c#L4365) — ERROR
- [`postgres/src/backend/utils/adt/int.c:805`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L805) — ERROR
- [`postgres/src/backend/utils/adt/int.c:827`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L827) — ERROR
- [`postgres/src/backend/utils/adt/int.c:841`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L841) — ERROR
- [`postgres/src/backend/utils/adt/int.c:855`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L855) — ERROR
- [`postgres/src/backend/utils/adt/int.c:886`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L886) — ERROR
- [`postgres/src/backend/utils/adt/int.c:907`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L907) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1024`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1024) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1038`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1038) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1052`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1052) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1085`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1085) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1099`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1099) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1113`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1113) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1144`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1144) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1227`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1227) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1291`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1291) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1359`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1359) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1365`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1365) — ERROR
- [`postgres/src/backend/utils/adt/numeric.c:2025`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L2025) — ERROR
- [`postgres/src/backend/utils/adt/varbit.c:1193`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/varbit.c#L1193) — ERROR
- [`postgres/src/backend/utils/adt/varlena.c:873`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/varlena.c#L873) — ERROR

## SQLSTATE

- `22003` — **ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE**. Class 22 (Data Exception).

## Related

- [smallint out of range](./smallint-out-of-range.md)
- [bigint out of range](./bigint-out-of-range.md)
