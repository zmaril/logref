---
message: "could not create large object %u: %s"
slug: could-not-create-large-object
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:1523"
reproduced: false
---

# `could not create large object %u: %s`

## What it means

During a restore, `pg_restore` could not create a large object in the target database. The `%u` is the object OID and `%s` gives the server's error. The large object could not be recreated.

## When it happens

It happens while `pg_restore` reloads large objects, when the server rejects the creation — for example an OID collision, insufficient privileges, or a server-side error.

## How to fix

Check the attached server error for the cause. Common fixes are restoring into a fresh database so OIDs do not collide, and running the restore as a role with rights to create large objects.

## Example

*Illustrative* — a large object that cannot be created during restore.

```text
pg_restore: fatal: could not create large object 16789: ERROR:  ...
```

## Related

- [could not create server file](./could-not-create-server-file.md)
- [could not create publication in database](./could-not-create-publication-in-database.md)
