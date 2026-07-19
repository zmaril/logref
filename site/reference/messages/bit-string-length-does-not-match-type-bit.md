---
message: "bit string length %d does not match type bit(%d)"
slug: bit-string-length-does-not-match-type-bit
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_STRING_DATA_LENGTH_MISMATCH
    code: "22026"
call_sites:
  - "postgres/src/backend/utils/adt/varbit.c:354"
reproduced: false
---

# `bit string length %d does not match type bit(%d)`

## What it means

A value assigned to a fixed-length `bit(n)` column or expression has a different number of bits than the type declares. The placeholders are the actual length and the declared width. Fixed-length bit strings must match their length exactly.

## When it happens

It occurs when inserting or casting a bit string into `bit(n)` whose length is not `n`.

## How to fix

Provide a bit string of the exact declared length, or use `bit varying(n)` if lengths vary up to a maximum. To fit a fixed `bit(n)`, pad or truncate the value explicitly so it has exactly `n` bits.

## Example

*Illustrative* — a length mismatch for bit.

```sql
SELECT B'101'::bit(4);
```

## Related

- [bit string too long for type bit varying](./bit-string-too-long-for-type-bit-varying.md)
- [bit string length exceeds the maximum allowed](./bit-string-length-exceeds-the-maximum-allowed.md)
