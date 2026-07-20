---
message: "Could not write to file \"%s\" at offset %d: %m"
slug: could-not-write-to-file-at-offset
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/slru.c:1136"
reproduced: false
---

# `Could not write to file "%s" at offset %d: %m`

## What it means

The SLRU layer could not write to a file at a specific offset. The placeholders are the file and the offset, and the trailing text is the operating-system error. SLRU backs on-disk structures such as commit-log and multixact data.

## When it happens

It fires when the server writes a page into an SLRU segment and the write fails — a full disk or an I/O error on the storage holding these structures.

## How to fix

Read the OS error. `No space left on device` on the filesystem holding directories like `pg_xact` or `pg_multixact` is serious — free space urgently. An I/O error points at failing storage; check the disk and kernel log. The server cannot advance transaction state until these writes succeed.

## Example

*Illustrative* — an SLRU write failed.

```text
ERROR:  Could not write to file "pg_xact/0000" at offset 8192: No space left on device
```

## Related

- [Could not write to file at offset (short write)](./could-not-write-to-file-at-offset-wrote-too-few-bytes.md)
- [could not seek in file to offset](./could-not-seek-in-file-to-offset.md)
