---
message: "could not read blocks %u..%u in file \"%s\": read only %zu of %zu bytes"
slug: could-not-read-blocks-in-file-read-only-of-bytes
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:965"
  - "postgres/src/backend/storage/smgr/md.c:2088"
reproduced: false
---

# `could not read blocks %u..%u in file "%s": read only %zu of %zu bytes`

## What it means

A read of data blocks returned fewer bytes than requested. The counts are what was read versus expected. A short read of a relation file at a valid offset indicates the file is shorter than the catalog thinks — a data-corruption signal.

## When it happens

The relation file was truncated, a filesystem lost the tail, or storage corruption shortened the file, while the server tried to read blocks it believed exist.

## How to fix

Treat this as corruption. Check storage health, verify the file's actual size against the expected size, and restore the relation from backup if the file was truncated. Investigate the underlying filesystem or device.

## Example

*Illustrative* — a short read from a truncated relation file.

```text
ERROR:  could not read blocks 5..6 in file "base/16384/16390": read only 4096 of 8192 bytes
```

## Related

- [could not read blocks in file](./could-not-read-blocks-in-file.md)
- [failed to find parent tuple for heap-only tuple](./failed-to-find-parent-tuple-for-heap-only-tuple-at-in-table.md)
