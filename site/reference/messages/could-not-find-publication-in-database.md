---
message: "could not find publication \"%s\" in database \"%s\": %s"
slug: could-not-find-publication-in-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:845"
reproduced: false
---

# `could not find publication "%s" in database "%s": %s`

## What it means

`pg_createsubscriber` could not find a publication it expected on a source database. The `%s` values name the publication and database and give the reason.

## When it happens

It happens during `pg_createsubscriber` when a publication it needs is absent from the source — for example a name given on the command line that does not exist there.

## How to fix

Check the publication name against what exists on the source database. Create the publication before running the tool, or supply a name that matches an existing one.

## Example

*Illustrative* — a named publication missing on the source.

```text
pg_createsubscriber: error: could not find publication "my_pub" in database "src": ...
```

## Related

- [could not create publication in database](./could-not-create-publication-in-database.md)
- [could not create subscription in database](./could-not-create-subscription-in-database.md)
