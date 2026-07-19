---
message: "could not create publication \"%s\" in database \"%s\": %s"
slug: could-not-create-publication-in-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1853"
reproduced: false
---

# `could not create publication "%s" in database "%s": %s`

## What it means

`pg_createsubscriber` could not create a publication on the source database it needs for the logical-replication setup it is building. The `%s` gives the server's error.

## When it happens

It happens during `pg_createsubscriber` when the `CREATE PUBLICATION` it issues on the source database fails — for example a name clash, or insufficient privileges.

## How to fix

Check the attached server error. Make sure the connecting role can create publications on the source database and that no publication of the same name already exists, then rerun.

## Example

*Illustrative* — publication creation failing during setup.

```text
pg_createsubscriber: error: could not create publication "pg_cs_pub" in database "src": ...
```

## Related

- [could not create subscription in database](./could-not-create-subscription-in-database.md)
- [could not create replication slot in database](./could-not-create-replication-slot-in-database.md)
