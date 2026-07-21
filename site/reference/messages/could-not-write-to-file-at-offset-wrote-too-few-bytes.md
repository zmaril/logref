---
message: "Could not write to file \"%s\" at offset %d: wrote too few bytes."
slug: could-not-write-to-file-at-offset-wrote-too-few-bytes
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/slru.c:1142"
reproduced: false
---

# `Could not write to file "%s" at offset %d: wrote too few bytes.`

## What it means

The SLRU layer wrote fewer bytes than a full page at a given offset, with no OS error — a short write. The placeholders are the file and the offset. SLRU segments hold fixed-size pages of transaction metadata.

## When it happens

It fires when a write into an SLRU segment returns short, which almost always means the filesystem ran out of space partway through the write.

## How to fix

A short write here means the disk holding the SLRU directory is essentially full. Free space on that filesystem immediately, since the server cannot record transaction state otherwise. If space was available, check the storage for I/O faults.

## Example

*Illustrative* — an SLRU write came up short.

```text
ERROR:  Could not write to file "pg_xact/0000" at offset 8192: wrote too few bytes.
```

## Related

- [Could not write to file at offset](./could-not-write-to-file-at-offset.md)
- [could not write to file, wrote N of M](./could-not-write-to-file-wrote-of.md)
