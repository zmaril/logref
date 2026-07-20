---
message: "collation \"%s\" already exists in schema \"%s\""
slug: collation-already-exists-in-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:419"
reproduced: false
---

# `collation "%s" already exists in schema "%s"`

## What it means

A `CREATE COLLATION` used a name that another collation in the target schema already has. Collation names must be unique within a schema, so the duplicate is rejected.

## When it happens

It occurs on `CREATE COLLATION name ...` when `name` already exists in the same schema.

## How to fix

Choose a different collation name, or drop the existing one with `DROP COLLATION` if you mean to replace it. Use `CREATE COLLATION IF NOT EXISTS` to skip creation when it already exists.

## Example

*Illustrative* — a duplicate collation name.

```sql
CREATE COLLATION mycoll (locale = 'en_US');
-- ERROR:  collation "mycoll" already exists in schema "public"
```

## Related

- [collation for encoding already exists in schema](./collation-for-encoding-already-exists-in-schema.md)
- [collation attribute not recognized](./collation-attribute-not-recognized.md)
