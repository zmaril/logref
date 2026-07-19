---
message: "collation \"%s\" for encoding \"%s\" does not exist"
slug: collation-for-encoding-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:4086"
reproduced: false
---

# `collation "%s" for encoding "%s" does not exist`

## What it means

A command referenced a collation by name that exists for some encoding but not for the database's current encoding. A collation must be defined for the encoding in use, and the named one is not, so it cannot be used here.

## When it happens

It occurs when a query or DDL names a collation that has no definition for the current database encoding.

## How to fix

Use a collation defined for this database's encoding, or create one with `CREATE COLLATION` for the needed encoding. List available collations with `\dO` in psql to find a match.

## Example

*Illustrative* — a collation missing for the encoding.

```text
ERROR:  collation "mycoll" for encoding "UTF8" does not exist
```

## Related

- [collation for encoding already exists in schema](./collation-for-encoding-already-exists-in-schema.md)
- [collation with OID does not exist](./collation-with-oid-does-not-exist.md)
