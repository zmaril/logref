---
message: "cannot subtract inet values of different sizes"
slug: cannot-subtract-inet-values-of-different-sizes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:1958"
reproduced: false
---

# `cannot subtract inet values of different sizes`

## What it means

Two `inet` or `cidr` values of different address families were subtracted. The minus operator on network addresses is defined only when both sides are the same family, so an IPv4 value cannot be subtracted from an IPv6 value.

## When it happens

It occurs in an expression such as `a - b` where `a` and `b` are network addresses from different families.

## How to fix

Subtract only addresses of the same family. Check the inputs and cast or filter so both operands are IPv4, or both IPv6, before the subtraction.

## Example

*Illustrative* — mixing address families.

```sql
SELECT inet '10.0.0.5' - inet '::1';
-- ERROR:  cannot subtract inet values of different sizes
```

## Related

- [cannot subtract infinite dates](./cannot-subtract-infinite-dates.md)
- [cannot subtract NaN from pg_lsn](./cannot-subtract-nan-from-pg-lsn.md)
