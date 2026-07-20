---
message: "bit string length exceeds the maximum allowed (%d)"
slug: bit-string-length-exceeds-the-maximum-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:992"
reproduced: false
---

# `bit string length exceeds the maximum allowed (%d)`

## What it means

A bit-string type was declared or a value was built with a length beyond the largest bit length Postgres supports. The placeholder is the maximum. Bit-string lengths are bounded.

## When it happens

It occurs when defining a `bit(n)` or `bit varying(n)` with an oversize `n`, or when an operation would produce a bit string longer than the limit.

## How to fix

Keep the declared or computed bit length within the supported maximum. For very large bit sets consider `bytea` or an application-level bitmap instead of the `bit` types.

## Example

*Illustrative* — an oversize bit length.

```text
ERROR:  bit string length exceeds the maximum allowed (83886080)
```

## Related

- [bit string length does not match type bit](./bit-string-length-does-not-match-type-bit.md)
- [bit string too long for type bit varying](./bit-string-too-long-for-type-bit-varying.md)
