---
message: "could not write archive status file \"%s\": %m"
slug: could-not-write-archive-status-file
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlogarchive.c:463"
  - "postgres/src/backend/access/transam/xlogarchive.c:543"
reproduced: false
---

# `could not write archive status file "%s": %m`

## What it means

The archiver or WAL machinery could not write a status file in `pg_wal/archive_status`; the errno string gives the operating-system reason.

## When it happens

It arises when updating a `.ready`/`.done` status file fails — commonly a full or read-only filesystem, or wrong permissions on `pg_wal/archive_status`.

## Is this a problem?

Check the errno. Ensure `pg_wal/archive_status` is writable by the server's user and the filesystem has free space and is not read-only. Archiving stalls until status files can be written.

## Example

*Illustrative* — a status file that could not be written.

```text
LOG:  could not write archive status file "pg_wal/archive_status/000000010000000000000001.done": No space left on device
```

## Related

- [could not create archive status file "%s": %m](./could-not-create-archive-status-file-61993b.md)
- [creating missing WAL directory "%s"](./creating-missing-wal-directory.md)
