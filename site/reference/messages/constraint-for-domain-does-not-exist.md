---
message: "constraint \"%s\" for domain %s does not exist"
slug: constraint-for-domain-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1427"
reproduced: true
---

# `constraint "%s" for domain %s does not exist`

## What it means

A statement referenced a domain constraint by name that the domain does not have. The named constraint could not be found on that domain.

## When it happens

It happens on `ALTER DOMAIN ... DROP CONSTRAINT` or `VALIDATE CONSTRAINT` when the constraint name is wrong or already dropped.

## How to fix

Use the correct constraint name, or add `IF EXISTS` to a drop to tolerate its absence. Check the domain's constraints before referencing them.

## Example

*Reproduced* — captured from `reproducers/scenarios/28_typecmds_domain_comment.sql`.

```sql
ALTER DOMAIN repro.posint RENAME CONSTRAINT nonexistent TO x;
```

Produces:

```text
ERROR:  constraint "nonexistent" for domain repro.posint does not exist
```

## Related

- [constraint for domain already exists](./constraint-for-domain-already-exists-3ea3c5.md)
- [constraint of domain is not a check constraint](./constraint-of-domain-is-not-a-check-constraint.md)
