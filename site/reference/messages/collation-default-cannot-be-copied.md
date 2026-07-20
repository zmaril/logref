---
message: "collation \"default\" cannot be copied"
slug: collation-default-cannot-be-copied
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:192"
reproduced: false
---

# `collation "default" cannot be copied`

## What it means

A `CREATE COLLATION ... FROM` tried to copy the special `default` collation. The `default` collation stands for the database's own collation rather than a concrete definition, so it cannot be copied.

## When it happens

It occurs on `CREATE COLLATION new (FROM "default")`.

## How to fix

Copy a concrete collation such as one named for a locale, or define the new collation directly with a `locale` or `provider` specification instead of copying `default`.

## Example

*Illustrative* — copying the default collation.

```sql
CREATE COLLATION c (FROM "default");
-- ERROR:  collation "default" cannot be copied
```

## Related

- [collation attribute not recognized](./collation-attribute-not-recognized.md)
- [collation with OID does not exist](./collation-with-oid-does-not-exist.md)
