---
message: "compressed lz4 data is corrupt"
slug: compressed-lz4-data-is-corrupt
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/common/toast_compression.c:200"
  - "postgres/src/backend/access/common/toast_compression.c:238"
reproduced: false
---

# `compressed lz4 data is corrupt`

## What it means

Postgres tried to decompress an LZ4-compressed datum (typically a TOASTed value) and the LZ4 decompressor reported the data is corrupt. The stored compressed bytes did not decode to a valid value, indicating data corruption.

## When it happens

Reading a column value that was compressed with LZ4 when the on-disk bytes have been damaged — from a storage fault, bad hardware, or a bug — so decompression fails.

## How to fix

Treat it as data corruption. Identify the affected row and column, and restore the value from a backup or a healthy replica if possible. Investigate the storage and memory subsystems for the root cause, since corruption tends to recur. Running data-integrity checks and reviewing recent hardware events helps locate the source.

## Example

*Illustrative* — a damaged LZ4-compressed value.

```text
ERROR:  compressed lz4 data is corrupt
```

## Related

- [compressed pglz data is corrupt](./compressed-pglz-data-is-corrupt.md)
- [corrupted item lengths total available space](./corrupted-item-lengths-total-available-space.md)
