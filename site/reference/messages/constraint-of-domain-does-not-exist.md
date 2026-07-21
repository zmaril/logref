---
message: "constraint \"%s\" of domain \"%s\" does not exist"
slug: constraint-of-domain-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:2936"
  - "postgres/src/backend/commands/typecmds.c:3121"
reproduced: true
---

# `constraint "%s" of domain "%s" does not exist`

## What it means

An `ALTER DOMAIN` named a constraint that the domain does not have. The placeholders are the constraint and the domain. The name is wrong, was already dropped, or belongs to a different domain.

## When it happens

`ALTER DOMAIN ... DROP CONSTRAINT` or `VALIDATE CONSTRAINT` referencing a constraint name not present on the domain.

## How to fix

Inspect the domain's constraints with `\dD+ domain` in psql (or `pg_constraint`) and use the exact name. Use `IF EXISTS` on the drop if you want it to tolerate an already-absent constraint.

## Example

*Reproduced* — captured from `reproducers/scenarios/28_typecmds_domain_comment.sql`.

```sql
ALTER DOMAIN repro.posint DROP CONSTRAINT nonexistent;
```

Produces:

```text
ERROR:  constraint "nonexistent" of domain "repro.posint" does not exist
```

## Related

- [constraint for domain already exists](./constraint-for-domain-already-exists-0f246d.md)
- [constraint for table does not exist](./constraint-for-table-does-not-exist.md)
