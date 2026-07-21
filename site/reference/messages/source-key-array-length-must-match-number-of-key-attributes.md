---
message: "source key array length must match number of key attributes"
slug: source-key-array-length-must-match-number-of-key-attributes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/dblink/dblink.c:1659"
  - "postgres/contrib/dblink/dblink.c:1824"
reproduced: false
---

# `source key array length must match number of key attributes`

## What it means

Internal error. An operation working with an index's or constraint's key attributes was handed a key array whose length does not equal the number of key columns. The two must agree element-for-element.

## When it happens

It fires from internal key-processing code (partitioning, index, or constraint machinery) when a passed key array's length disagrees with the number of key attributes. Ordinary SQL does not construct such a mismatch.

## How to fix

This is an internal consistency guard. If a real operation triggers it, capture the DDL/objects involved (especially any custom access method or partitioning code) and report it as a reproducible bug.

## Example

*Illustrative* — a key array of the wrong length.

```text
ERROR:  source key array length must match number of key attributes
```

## Related

- [source array too small](./source-array-too-small.md)
- [remainder for hash partition must be less than modulus](./remainder-for-hash-partition-must-be-less-than-modulus.md)
