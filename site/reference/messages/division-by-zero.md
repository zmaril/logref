---
message: "division by zero"
slug: division-by-zero
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DIVISION_BY_ZERO
    code: "22012"
call_sites:
  - "postgres/src/backend/utils/adt/cash.c:160"
  - "postgres/src/backend/utils/adt/cash.c:729"
  - "postgres/src/backend/utils/adt/float.c:121"
  - "postgres/src/backend/utils/adt/int.c:870"
  - "postgres/src/backend/utils/adt/int.c:986"
  - "postgres/src/backend/utils/adt/int.c:1066"
  - "postgres/src/backend/utils/adt/int.c:1128"
  - "postgres/src/backend/utils/adt/int.c:1166"
  - "postgres/src/backend/utils/adt/int.c:1194"
  - "postgres/src/backend/utils/adt/int8.c:519"
  - "postgres/src/backend/utils/adt/int8.c:579"
  - "postgres/src/backend/utils/adt/int8.c:979"
  - "postgres/src/backend/utils/adt/int8.c:1059"
  - "postgres/src/backend/utils/adt/int8.c:1121"
  - "postgres/src/backend/utils/adt/int8.c:1201"
  - "postgres/src/backend/utils/adt/numeric.c:3282"
  - "postgres/src/backend/utils/adt/numeric.c:3300"
  - "postgres/src/backend/utils/adt/numeric.c:8945"
  - "postgres/src/backend/utils/adt/numeric.c:9469"
  - "postgres/src/backend/utils/adt/numeric.c:9585"
  - "postgres/src/backend/utils/adt/numeric.c:11096"
  - "postgres/src/backend/utils/adt/timestamp.c:3771"
  - "postgres/src/bin/pgbench/pgbench.c:2402"
reproduced: true
---

# `division by zero`

## What it means

An arithmetic operation tried to divide by zero. Division and the modulo (remainder) operator are undefined when the divisor is zero, so Postgres raises an error instead of returning infinity or a null.

## When it happens

Any `/` or `%` where the right operand evaluates to zero — including the integer, `numeric`, `money`, and floating-point variants, and functions like `mod()` and `div()`. In real workloads the divisor is usually a column or aggregate that happened to be zero for some rows.

## How to fix

Guard the divisor. The idiomatic Postgres guard is `NULLIF`: `SELECT total / NULLIF(count, 0)` yields `NULL` instead of erroring when `count` is zero. Or filter the zero rows out in a `WHERE` clause, or wrap the division in a `CASE WHEN divisor = 0 THEN NULL ELSE a / divisor END`. Decide deliberately whether a zero divisor should be null, a default, or a skipped row.

## Example

*Reproduced* — The numeric-math reproducer scenario (`12_numeric_math.sql`).

```sql
SELECT 1 / 0;
```

Produces:

```text
ERROR:  division by zero
```

## Related

- [integer out of range](./integer-out-of-range.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
