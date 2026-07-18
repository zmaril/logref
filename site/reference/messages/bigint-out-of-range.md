---
message: "bigint out of range"
slug: bigint-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/contrib/btree_gist/btree_int8.c:106"
  - "postgres/src/backend/utils/adt/int8.c:453"
  - "postgres/src/backend/utils/adt/int8.c:476"
  - "postgres/src/backend/utils/adt/int8.c:490"
  - "postgres/src/backend/utils/adt/int8.c:504"
  - "postgres/src/backend/utils/adt/int8.c:535"
  - "postgres/src/backend/utils/adt/int8.c:560"
  - "postgres/src/backend/utils/adt/int8.c:643"
  - "postgres/src/backend/utils/adt/int8.c:711"
  - "postgres/src/backend/utils/adt/int8.c:717"
  - "postgres/src/backend/utils/adt/int8.c:734"
  - "postgres/src/backend/utils/adt/int8.c:748"
  - "postgres/src/backend/utils/adt/int8.c:936"
  - "postgres/src/backend/utils/adt/int8.c:950"
  - "postgres/src/backend/utils/adt/int8.c:964"
  - "postgres/src/backend/utils/adt/int8.c:995"
  - "postgres/src/backend/utils/adt/int8.c:1017"
  - "postgres/src/backend/utils/adt/int8.c:1031"
  - "postgres/src/backend/utils/adt/int8.c:1045"
  - "postgres/src/backend/utils/adt/int8.c:1078"
  - "postgres/src/backend/utils/adt/int8.c:1092"
  - "postgres/src/backend/utils/adt/int8.c:1106"
  - "postgres/src/backend/utils/adt/int8.c:1137"
  - "postgres/src/backend/utils/adt/int8.c:1159"
  - "postgres/src/backend/utils/adt/int8.c:1173"
  - "postgres/src/backend/utils/adt/int8.c:1187"
reproduced: true
---

# `bigint out of range`

**Severity:** ERROR · SQLSTATE `22003` (ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE)

## What it means

A value overflowed `bigint` (`int8`), a signed 64-bit integer spanning -9223372036854775808 to 9223372036854775807. This is the widest native integer Postgres has, so hitting its edge usually signals runaway arithmetic rather than a too-narrow column.

## When it happens

Arithmetic on `bigint` values whose result exceeds 64 bits — a `sum()` over a huge dataset, `factorial()`, repeated multiplication, or adding one to the maximum value. Also on input of a numeric literal larger than the `bigint` range.

## How to fix

Switch the calculation to `numeric`, which is arbitrary-precision: `SELECT sum(x::numeric)`. `numeric` is slower and larger on disk, so use it only where the magnitude truly demands it. If the overflow is in an aggregate, consider whether the query is summing the wrong grain of data.

## Example

*Reproduced* — Overflowing the top of the 64-bit range (`03_types_range_cast.sql`).

```sql
SELECT 9223372036854775807::int8 + 1;
```

Produces:

```text
ERROR:  bigint out of range
```

## Source

This message text is emitted from 26 call sites:

- [`postgres/contrib/btree_gist/btree_int8.c:106`](https://github.com/postgres/postgres/blob/master/contrib/btree_gist/btree_int8.c#L106) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:453`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L453) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:476`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L476) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:490`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L490) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:504`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L504) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:535`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L535) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:560`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L560) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:643`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L643) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:711`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L711) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:717`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L717) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:734`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L734) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:748`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L748) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:936`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L936) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:950`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L950) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:964`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L964) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:995`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L995) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1017`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1017) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1031`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1031) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1045`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1045) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1078`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1078) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1092`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1092) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1106`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1106) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1137`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1137) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1159`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1159) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1173`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1173) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1187`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1187) — ERROR

## SQLSTATE

- `22003` — **ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE**. Class 22 (Data Exception).

## Related

- [integer out of range](./integer-out-of-range.md)
- [smallint out of range](./smallint-out-of-range.md)
