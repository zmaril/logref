---
message: "could not create subscription \"%s\" in database \"%s\": %s"
slug: could-not-create-subscription-in-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2027"
reproduced: false
---

# `could not create subscription "%s" in database "%s": %s`

## What it means

`pg_createsubscriber` could not create a subscription on the target database while converting a standby into a subscriber. The `%s` gives the server's error.

## When it happens

It happens during `pg_createsubscriber` when the `CREATE SUBSCRIPTION` on the target database fails — for example a name clash, or insufficient privileges.

## How to fix

Check the attached server error. Make sure the connecting role can create subscriptions on the target and no subscription of the same name exists, then rerun.

## Example

*Illustrative* — subscription creation failing during setup.

```text
pg_createsubscriber: error: could not create subscription "pg_cs_sub" in database "tgt": ...
```

## Related

- [could not create publication in database](./could-not-create-publication-in-database.md)
- [could not create replication slot in database](./could-not-create-replication-slot-in-database.md)
