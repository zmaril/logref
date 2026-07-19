---
message: "could not drop publication \"%s\" in database \"%s\": %s"
slug: could-not-drop-publication-in-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1900"
reproduced: false
---

# `could not drop publication "%s" in database "%s": %s`

## What it means

`pg_createsubscriber` could not drop a publication it had created on a source database during cleanup. The `%s` gives the server's error.

## When it happens

It happens during `pg_createsubscriber` cleanup when `DROP PUBLICATION` on the source database fails — for example the publication was already removed, or the connecting role lacks privileges.

## How to fix

Check the attached server error. Drop any leftover publication by hand once the tool finishes, and confirm the connecting role owns it or has the needed privileges.

## Example

*Illustrative* — publication cleanup failing.

```text
pg_createsubscriber: error: could not drop publication "pg_cs_pub" in database "src": ...
```

## Related

- [could not create publication in database](./could-not-create-publication-in-database.md)
- [could not drop replication slot in database](./could-not-drop-replication-slot-in-database.md)
