---
message: "comment creation failed (database was created): %s"
slug: comment-creation-failed-database-was-created
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/scripts/createdb.c:281"
reproduced: false
---

# `comment creation failed (database was created): %s`

## What it means

`createdb` successfully created the database but then failed to apply the `COMMENT` requested with `--comment`. The database exists; only the comment could not be set.

## When it happens

It happens with `createdb --comment '...'` when the `COMMENT ON DATABASE` step fails, for example due to a permission or connection problem after creation.

## How to fix

The database is already created, so do not recreate it. Set the comment yourself with `COMMENT ON DATABASE name IS '...'` once you resolve the underlying cause shown in the message.

## Example

*Illustrative* — the comment step failing after creation.

```text
createdb: error: comment creation failed (database was created): ...
```

## Related

- [connection to database failed](./connection-to-database-failed-ed5fa7.md)
- [could not change directory to](./could-not-change-directory-to-41f86e.md)
