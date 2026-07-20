---
message: "warning from original dump file: %s"
slug: warning-from-original-dump-file
passthrough: false
api: [pg_log_warning]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:858"
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:860"
reproduced: false
---

# `warning from original dump file: %s`

## What it means

A restore is relaying a warning that was recorded in the dump archive when it was originally created, prefixing it so you know its source.

## When it happens

It is emitted at WARNING by `pg_restore` when the archive contains a stored warning from `pg_dump` time, replayed as the archive is processed.

## Is this a problem?

Read the relayed warning text after the prefix — it describes something noticed when the dump was taken (for example an object that could not be fully represented). Address that underlying issue at the source database if it matters; the restore itself continues.

## Example

*Illustrative* — a dump-time warning surfaced during restore.

```text
WARNING:  warning from original dump file: could not resolve dependency
```

## Related

- [restoring large object with OID](./restoring-large-object-with-oid.md)
- [archive file already exists](./archive-file-already-exists.md)
