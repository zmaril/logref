---
message: "publication \"%s\" already exists"
slug: publication-already-exists
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:876"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1828"
reproduced: false
---

# `publication "%s" already exists`

## What it means

A `CREATE PUBLICATION` named a publication that already exists. The placeholder is the publication name. Publication names are unique within a database.

## When it happens

It arises when re-creating a publication that is already present — a re-run migration, or a naming collision with an existing publication.

## How to fix

Use a different name, or modify the existing publication with `ALTER PUBLICATION`. Add `IF NOT EXISTS`-style idempotency in migrations, or drop the old publication first with `DROP PUBLICATION` if replacing it.

## Example

*Illustrative* — creating a publication that already exists.

```text
ERROR:  publication "pub_orders" already exists
```

## Related

- [publication "%s" is defined as FOR ALL TABLES](./publication-is-defined-as-for-all-tables.md)
- [subscription with OID %u does not exist](./subscription-with-oid-does-not-exist.md)
