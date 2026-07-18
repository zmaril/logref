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

## Related

- [integer out of range](./integer-out-of-range.md)
- [smallint out of range](./smallint-out-of-range.md)
