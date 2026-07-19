---
message: "could not drop replication slot \"%s\" in database \"%s\": %s"
slug: could-not-drop-replication-slot-in-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1629"
reproduced: false
---

# `could not drop replication slot "%s" in database "%s": %s`

## What it means

`pg_createsubscriber` could not drop a replication slot in a source database during cleanup. The `%s` gives the server's error.

## When it happens

It happens during `pg_createsubscriber` cleanup when dropping a slot on the source fails — for example the slot is still active, or was already removed.

## How to fix

Check the attached server error. Remove any leftover slot by hand with `pg_drop_replication_slot` once it is inactive, and confirm the connecting role has replication privileges.

## Example

*Illustrative* — slot cleanup failing.

```text
pg_createsubscriber: error: could not drop replication slot "pg_cs_slot" in database "src": ...
```

## Related

- [could not create replication slot in database](./could-not-create-replication-slot-in-database.md)
- [could not drop publication in database](./could-not-drop-publication-in-database.md)
