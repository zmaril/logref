---
message: "case insensitive matching not supported on type bytea"
slug: case-insensitive-matching-not-supported-on-type-bytea
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/like_support.c:1094"
reproduced: false
---

# `case insensitive matching not supported on type bytea`

## What it means

A case-insensitive match operator such as `ILIKE` or a case-insensitive regular expression was applied to a `bytea` value. Binary data has no case, so case-insensitive matching is not defined for it.

## When it happens

It occurs when `ILIKE`, `~*`, or a similar case-insensitive operator is used with a `bytea` operand.

## How to fix

Convert the binary value to `text` with a known encoding first if it holds character data, or use a case-sensitive operator such as `LIKE` on the `bytea` value.

## Example

*Illustrative* — ILIKE on bytea.

```sql
SELECT '\x41'::bytea ILIKE 'a';
-- ERROR:  case insensitive matching not supported on type bytea
```

## Related

- [cannot XOR bit strings of different sizes](./cannot-xor-bit-strings-of-different-sizes.md)
- [case not found](./case-not-found.md)
