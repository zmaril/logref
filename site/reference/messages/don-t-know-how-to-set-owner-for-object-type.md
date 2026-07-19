---
message: "don't know how to set owner for object type \"%s\""
slug: don-t-know-how-to-set-owner-for-object-type
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:3925"
reproduced: false
---

# `don't know how to set owner for object type "%s"`

## What it means

During a restore, `pg_restore` encountered an archive entry whose object type it does not know how to assign ownership for. The placeholder is the object-type label. It usually means the archive is from a newer or unexpected PostgreSQL version.

## When it happens

It fires in `pg_restore` while applying ownership (`ALTER ... OWNER TO`) for an archive item of a type the running `pg_restore` does not recognize.

## How to fix

Use a `pg_restore` at least as new as the `pg_dump` that produced the archive. If versions match, the archive may be damaged. Restoring with `--no-owner` skips ownership assignment and sidesteps the specific step if you can set ownership afterward.

## Example

*Illustrative* — an unrecognized object type during restore.

```text
pg_restore: error: don't know how to set owner for object type FOO
```

## Related

- [direct database connections are not supported in pre-1.3 archives](./direct-database-connections-are-not-supported-in-pre-1-3-archives.md)
- [did not find magic string in file header](./did-not-find-magic-string-in-file-header.md)
