---
message: "could not create replication slot \"%s\" in database \"%s\": %s"
slug: could-not-create-replication-slot-in-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1579"
reproduced: false
---

# `could not create replication slot "%s" in database "%s": %s`

## What it means

`pg_createsubscriber` could not create a replication slot in a source database while building its logical-replication setup. The `%s` gives the server's error.

## When it happens

It happens during `pg_createsubscriber` when the slot-creation call on the source database fails — for example a name clash or exhausted `max_replication_slots`.

## How to fix

Check the attached server error. Free replication-slot capacity on the source, avoid a name clash, and confirm the connecting role has replication privileges, then rerun.

## Example

*Illustrative* — slot creation failing during setup.

```text
pg_createsubscriber: error: could not create replication slot "pg_cs_slot" in database "src": ...
```

## Related

- [could not create publication in database](./could-not-create-publication-in-database.md)
- [could not create subscription in database](./could-not-create-subscription-in-database.md)
