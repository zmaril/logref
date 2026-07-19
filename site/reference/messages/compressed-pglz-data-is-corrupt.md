---
message: "compressed pglz data is corrupt"
slug: compressed-pglz-data-is-corrupt
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/common/toast_compression.c:96"
  - "postgres/src/backend/access/common/toast_compression.c:124"
reproduced: false
---

# `compressed pglz data is corrupt`

## What it means

Postgres tried to decompress a pglz-compressed datum (typically a TOASTed value) and found the data corrupt. pglz is the built-in compression method; the stored compressed bytes did not decode to a valid value, indicating data corruption.

## When it happens

Reading a column value compressed with pglz when the on-disk bytes have been damaged — from a storage fault, bad hardware, or a bug — so decompression fails.

## How to fix

Treat it as data corruption. Locate the affected row and column and restore the value from a backup or healthy replica. Investigate storage and memory health for the underlying cause, and run integrity checks to find any other damaged data.

## Example

*Illustrative* — a damaged pglz-compressed value.

```text
ERROR:  compressed pglz data is corrupt
```

## Related

- [compressed lz4 data is corrupt](./compressed-lz4-data-is-corrupt.md)
- [corrupted item lengths total available space](./corrupted-item-lengths-total-available-space.md)
