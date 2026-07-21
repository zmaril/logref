---
message: "cannot OR inet values of different sizes"
slug: cannot-or-inet-values-of-different-sizes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:1856"
reproduced: false
---

# `cannot OR inet values of different sizes`

## What it means

A bitwise OR was applied to two `inet` values whose address families differ. Combining network addresses bit by bit requires both to be the same family and size, and an IPv4 and IPv6 value do not match.

## When it happens

It occurs when the `|` operator combines an IPv4 `inet` with an IPv6 `inet`.

## How to fix

Operate on addresses of a single family. Filter or convert the values so both are IPv4 or both are IPv6 before combining them.

## Example

*Illustrative* — OR of inet values of different families.

```text
ERROR:  cannot OR inet values of different sizes
```

## Related

- [cannot OR bit strings of different sizes](./cannot-or-bit-strings-of-different-sizes.md)
- [cannot merge addresses from different families](./cannot-merge-addresses-from-different-families.md)
