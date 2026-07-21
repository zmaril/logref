---
message: "argument of ntile must be greater than zero"
slug: argument-of-ntile-must-be-greater-than-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_NTILE
    code: "22014"
call_sites:
  - "postgres/src/backend/utils/adt/windowfuncs.c:447"
reproduced: true
---

# `argument of ntile must be greater than zero`

## What it means

The `ntile` window function was given a bucket count of zero or negative, but it must be a positive integer specifying how many buckets to divide the partition into.

## When it happens

It occurs when `ntile(n)` is called with `n <= 0`.

## How to fix

Pass a positive integer for the number of buckets. If the count is computed, ensure it is at least 1 before the call.

## Example

*Reproduced* — captured from `reproducers/scenarios/23_query_semantics_extended.sql`.

```sql
SELECT ntile(0) OVER () FROM repro.parent;
```

Produces:

```text
ERROR:  argument of ntile must be greater than zero
```

## Related

- [argument of nth_value must be greater than zero](./argument-of-nth-value-must-be-greater-than-zero.md)
- [a negative integer value cannot be specified for](./a-negative-integer-value-cannot-be-specified-for.md)
