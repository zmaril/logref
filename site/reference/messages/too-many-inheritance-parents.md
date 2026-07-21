---
message: "too many inheritance parents"
slug: too-many-inheritance-parents
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2867"
  - "postgres/src/backend/catalog/pg_constraint.c:801"
  - "postgres/src/backend/catalog/pg_constraint.c:1154"
  - "postgres/src/backend/commands/tablecmds.c:3266"
  - "postgres/src/backend/commands/tablecmds.c:3586"
  - "postgres/src/backend/commands/tablecmds.c:7435"
  - "postgres/src/backend/commands/tablecmds.c:8116"
  - "postgres/src/backend/commands/tablecmds.c:18299"
  - "postgres/src/backend/commands/tablecmds.c:18481"
reproduced: false
---

# `too many inheritance parents`

## What it means

A table was defined to inherit from more than the supported number of parent tables. Postgres allows multiple inheritance, but the number of direct parents is bounded; exceeding it is rejected as a program-limit error.

## When it happens

`CREATE TABLE ... INHERITS (many parents)` or `ALTER TABLE ... INHERIT` pushing a table past the parent limit, typically in unusual schemas that fan in a very large number of parents.

## How to fix

Reduce the number of direct parents. Reconsider the schema — very wide multiple inheritance is uncommon and often better modeled with a single parent plus columns, or with partitioning for the range/list case. If you were emulating partitioning with inheritance, use declarative partitioning instead.

## Example

*Illustrative* — inheriting from too many parents.

```sql
CREATE TABLE child () INHERITS (p1, p2, /* ...very many... */);
```

Produces:

```text
ERROR:  too many inheritance parents
```

## Related

- [constraint for relation already exists](./constraint-for-relation-already-exists.md)
- [cannot convert whole-row table reference](./cannot-convert-whole-row-table-reference.md)
