---
message: "constraint \"%s\" for domain \"%s\" already exists"
slug: constraint-for-domain-already-exists-0f246d
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3566"
  - "postgres/src/backend/commands/typecmds.c:3722"
reproduced: false
---

# `constraint "%s" for domain "%s" already exists`

## What it means

A `CREATE DOMAIN` or `ALTER DOMAIN ... ADD CONSTRAINT` used a constraint name already present on the domain. The placeholders are the constraint and the domain. Constraint names must be unique within a domain.

## When it happens

Adding a domain constraint whose name is already taken — a re-run migration, or an explicit name that collides with an existing constraint on the domain.

## How to fix

Choose a different constraint name, or drop the existing constraint first if you mean to replace it. Query the domain's constraints (`\dD+ domain` in psql) to see the names already in use.

## Example

*Illustrative* — a duplicate domain constraint name.

```sql
ALTER DOMAIN d ADD CONSTRAINT chk CHECK (VALUE > 0);
-- ERROR:  constraint "chk" for domain "d" already exists
```

## Related

- [constraint of domain does not exist](./constraint-of-domain-does-not-exist.md)
- [collation already exists](./collation-already-exists.md)
