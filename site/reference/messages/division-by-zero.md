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

**Severity:** ERROR · SQLSTATE `22012` (ERRCODE_DIVISION_BY_ZERO)

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

## Source

This message text is emitted from 23 call sites:

- [`postgres/src/backend/utils/adt/cash.c:160`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/cash.c#L160) — ERROR
- [`postgres/src/backend/utils/adt/cash.c:729`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/cash.c#L729) — ERROR
- [`postgres/src/backend/utils/adt/float.c:121`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/float.c#L121) — ERROR
- [`postgres/src/backend/utils/adt/int.c:870`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L870) — ERROR
- [`postgres/src/backend/utils/adt/int.c:986`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L986) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1066`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1066) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1128`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1128) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1166`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1166) — ERROR
- [`postgres/src/backend/utils/adt/int.c:1194`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int.c#L1194) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:519`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L519) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:579`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L579) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:979`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L979) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1059`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1059) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1121`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1121) — ERROR
- [`postgres/src/backend/utils/adt/int8.c:1201`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/int8.c#L1201) — ERROR
- [`postgres/src/backend/utils/adt/numeric.c:3282`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L3282) — ERROR
- [`postgres/src/backend/utils/adt/numeric.c:3300`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L3300) — ERROR
- [`postgres/src/backend/utils/adt/numeric.c:8945`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L8945) — ERROR
- [`postgres/src/backend/utils/adt/numeric.c:9469`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L9469) — ERROR
- [`postgres/src/backend/utils/adt/numeric.c:9585`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L9585) — ERROR
- [`postgres/src/backend/utils/adt/numeric.c:11096`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/numeric.c#L11096) — ERROR
- [`postgres/src/backend/utils/adt/timestamp.c:3771`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/timestamp.c#L3771) — ERROR
- [`postgres/src/bin/pgbench/pgbench.c:2402`](https://github.com/postgres/postgres/blob/master/src/bin/pgbench/pgbench.c#L2402) — ERROR

## SQLSTATE

- `22012` — **ERRCODE_DIVISION_BY_ZERO**. Class 22 (Data Exception).

## Related

- [integer out of range](./integer-out-of-range.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
