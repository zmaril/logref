---
message: "bit string too long for type bit varying(%d)"
slug: bit-string-too-long-for-type-bit-varying
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_STRING_DATA_RIGHT_TRUNCATION
    code: "22001"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:659"
reproduced: false
---

# `bit string too long for type bit varying(%d)`

## What it means

A value assigned to `bit varying(n)` has more than `n` bits. The placeholder is the declared maximum. Unlike fixed `bit(n)`, varying bit strings may be shorter than the maximum but not longer.

## When it happens

It occurs when inserting or casting a bit string longer than the maximum length declared for a `bit varying(n)` column.

## How to fix

Shorten the value to at most `n` bits, or increase the column's declared length. If truncation is acceptable, cast through a wider `bit varying` and trim explicitly rather than relying on silent loss.

## Example

*Illustrative* — a value exceeding a varbit maximum.

```sql
SELECT B'10101'::bit varying(4);
```

## Related

- [bit string length does not match type bit](./bit-string-length-does-not-match-type-bit.md)
- [bit string length exceeds the maximum allowed](./bit-string-length-exceeds-the-maximum-allowed.md)
