---
message: "could not seek in file \"%s\" to offset %d: %m"
slug: could-not-seek-in-file-to-offset
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/slru.c:1115"
reproduced: false
---

# `could not seek in file "%s" to offset %d: %m`

## What it means

The SLRU layer could not seek to a byte offset in one of its files. The placeholders are the file and the offset, and the trailing text is the operating-system error. SLRU backs on-disk structures like commit-log and multixact data.

## When it happens

It fires when the server repositions within an SLRU segment to read or write a page and the seek fails — an I/O error on the storage, or a segment that is shorter than expected.

## How to fix

Read the OS error. An I/O failure means the storage under the affected directory (such as `pg_xact` or `pg_multixact`) is faulty — check the disk and kernel log. A short file suggests corruption; preserve it and, depending on which SLRU it is, restoring from a backup may be needed. This is not a query-level problem.

## Example

*Illustrative* — a seek in an SLRU segment failed.

```text
ERROR:  could not seek in file "pg_xact/0000" to offset 8192: Input/output error
```

## Related

- [could not write to file at offset](./could-not-write-to-file-at-offset.md)
- [could not truncate file to blocks](./could-not-truncate-file-to-blocks.md)
