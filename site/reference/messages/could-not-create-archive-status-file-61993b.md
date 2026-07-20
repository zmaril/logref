---
message: "could not create archive status file \"%s\": %m"
slug: could-not-create-archive-status-file-61993b
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/access/transam/xlogarchive.c:455"
  - "postgres/src/backend/access/transam/xlogarchive.c:535"
reproduced: false
---

# `could not create archive status file "%s": %m`

## What it means

The archiver or WAL machinery could not create a status file in `pg_wal/archive_status` that marks a WAL segment ready to archive; the errno string gives the reason.

## When it happens

It arises when a `.ready`/`.done` status file cannot be created — commonly a full or read-only filesystem, or wrong permissions on `pg_wal/archive_status`.

## Is this a problem?

Check the errno. Ensure `pg_wal/archive_status` exists, is writable by the server's user, and that the filesystem has free space and is not read-only. Archiving stalls until status files can be written.

## Example

*Illustrative* — a status file that cannot be created.

```text
LOG:  could not create archive status file "pg_wal/archive_status/000000010000000000000001.ready": No space left on device
```

## Related

- [could not write archive status file "%s": %m](./could-not-write-archive-status-file.md)
- [creating missing WAL directory "%s"](./creating-missing-wal-directory.md)
