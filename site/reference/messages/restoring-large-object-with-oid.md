---
message: "restoring large object with OID %u"
slug: restoring-large-object-with-oid
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1511"
  - "postgres/src/bin/pg_dump/pg_backup_tar.c:683"
reproduced: false
---

# `restoring large object with OID %u`

## What it means

A restore is recreating a large object and reports the OID it is being restored under.

## When it happens

It is printed at INFO by `pg_restore`/`psql` while replaying a dump that contains large objects, one line per object as it is created.

## Is this a problem?

This is progress output during a restore, not a problem. No action is needed. If a restore fails later, the failure message that follows is what to look at.

## Example

*Illustrative* — a restore recreating a large object.

```text
INFO:  restoring large object with OID 16487
```

## Related

- [warning from original dump file](./warning-from-original-dump-file.md)
- [archive file already exists](./archive-file-already-exists.md)
