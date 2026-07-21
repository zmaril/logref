---
message: "could not find block ID %d in archive -- possibly due to out-of-order restore request, which cannot be handled due to non-seekable input file"
slug: could-not-find-block-id-in-archive-possibly-due-to-out-of-order-restore-request
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_custom.c:518"
reproduced: false
---

# `could not find block ID %d in archive -- possibly due to out-of-order restore request, which cannot be handled due to non-seekable input file`

## What it means

`pg_restore` looked for a data block by its ID in a custom-format archive read from a non-seekable input and could not find it. Because the input cannot be rewound, an out-of-order request for the block cannot be satisfied.

## When it happens

It happens when restoring from a custom-format dump piped in (not a regular file) with a restore order that needs to seek backward, which a non-seekable stream cannot do.

## How to fix

Restore from a regular file rather than a pipe so `pg_restore` can seek, or avoid options that reorder items (such as selective or parallel restore) when reading from a stream. Writing the dump to disk first resolves it.

## Example

*Illustrative* — an out-of-order block on a non-seekable input.

```text
pg_restore: fatal: could not find block ID 42 in archive -- possibly due to out-of-order restore request, which cannot be handled due to non-seekable input file
```

## Related

- [could not find block ID in archive (possibly corrupt archive)](./could-not-find-block-id-in-archive-possibly-corrupt-archive.md)
- [could not find file in archive](./could-not-find-file-in-archive.md)
