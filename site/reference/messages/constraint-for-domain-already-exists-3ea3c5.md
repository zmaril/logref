---
message: "constraint \"%s\" for domain %s already exists"
slug: constraint-for-domain-already-exists-3ea3c5
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1033"
reproduced: false
---

# `constraint "%s" for domain %s already exists`

## What it means

A constraint being added to a domain uses a name already taken by another constraint on that domain. Constraint names must be unique within a domain.

## When it happens

It happens on `ALTER DOMAIN ... ADD CONSTRAINT name ...` when the domain already has a constraint with that name.

## How to fix

Choose a different constraint name, or drop the existing one first. List the domain's constraints in `pg_constraint` (or `\dD` details) to see which names are in use.

## Example

*Illustrative* — a duplicate constraint name on a domain.

```sql
ALTER DOMAIN d ADD CONSTRAINT c CHECK (VALUE > 0);
ALTER DOMAIN d ADD CONSTRAINT c CHECK (VALUE < 100);
-- ERROR:  constraint "c" for domain d already exists
```

## Related

- [constraint for domain does not exist](./constraint-for-domain-does-not-exist.md)
- [constraint of domain is not a check constraint](./constraint-of-domain-is-not-a-check-constraint.md)
