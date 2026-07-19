---
message: "byte ordering mismatch"
slug: byte-ordering-mismatch
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/common/controldata_utils.c:169"
reproduced: false
---

# `byte ordering mismatch`

## What it means

A routine that reads a raw on-disk page or binary structure detected that the data's byte order does not match the current machine's. Postgres data files are not portable across architectures of different endianness, and the mismatch was caught while decoding.

## When it happens

It typically arises when a `pageinspect`-style function or a low-level reader is handed a page image produced on a machine with the opposite endianness, or when a data file was copied between incompatible architectures.

## How to fix

Read pages on an architecture matching the one that produced them. Data files and raw page images cannot be moved between big-endian and little-endian systems; migrate such data with `pg_dump`/`pg_restore` or logical replication instead of copying files.

## Example

*Illustrative* — a page from a different-endian machine.

```text
ERROR:  byte ordering mismatch
```

## Related

- [byval datum but length](./byval-datum-but-length.md)
- [calculated crc checksum does not match value stored in file](./calculated-crc-checksum-does-not-match-value-stored-in-file-12a806.md)
