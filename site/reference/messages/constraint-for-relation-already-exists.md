---
message: "constraint \"%s\" for relation \"%s\" already exists"
slug: constraint-for-relation-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2672"
  - "postgres/src/backend/catalog/heap.c:2798"
  - "postgres/src/backend/catalog/heap.c:3051"
  - "postgres/src/backend/catalog/index.c:918"
  - "postgres/src/backend/catalog/pg_constraint.c:1025"
  - "postgres/src/backend/commands/tablecmds.c:9965"
reproduced: false
---

# `constraint "%s" for relation "%s" already exists`

## What it means

A constraint could not be added because the relation already has one with that name. The first placeholder is the constraint name, the second the relation. Constraint names must be unique per relation, and the name is taken.

## When it happens

`ALTER TABLE ... ADD CONSTRAINT name ...` reusing a name, re-running a migration that adds the same constraint, or a name clash with an auto-generated constraint name. Inherited constraints from a parent table can also collide.

## How to fix

Choose a different constraint name, or drop the existing one first if it is obsolete (`ALTER TABLE ... DROP CONSTRAINT name`). Check existing constraints with `\d relation`. For idempotent migrations, guard the add or use a name that will not collide with inherited or auto-generated constraints.

## Example

*Illustrative* — adding a constraint whose name is taken.

```sql
ALTER TABLE orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
```

Produces:

```text
ERROR:  constraint "orders_pkey" for relation "orders" already exists
```

## Related

- [type "%s" already exists](./type-already-exists.md)
- [relation "%s" already exists](./relation-already-exists.md)
