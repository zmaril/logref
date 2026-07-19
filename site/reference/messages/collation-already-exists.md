---
message: "collation \"%s\" already exists"
slug: collation-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_collation.c:108"
  - "postgres/src/backend/catalog/pg_collation.c:164"
reproduced: false
---

# `collation "%s" already exists`

## What it means

A `CREATE COLLATION` named a collation that already exists in the target schema. The placeholder is the collation name. Two collations with the same name cannot coexist in one schema.

## When it happens

Creating a collation whose name is already taken — a re-run of a creation script, a name collision with a system-provided collation, or importing collations that duplicate existing ones.

## How to fix

Use `CREATE COLLATION IF NOT EXISTS` to skip when it already exists, choose a different name, or drop the existing collation first if you intend to redefine it. Check `pg_collation` for the current name before creating.

## Example

*Illustrative* — recreating an existing collation.

```sql
CREATE COLLATION mycoll (locale = 'en_US');
-- ERROR:  collation "mycoll" already exists
```

## Related

- [collation failed](./collation-failed.md)
- [constraint for domain already exists](./constraint-for-domain-already-exists-0f246d.md)
