---
message: "circular inheritance not allowed"
slug: circular-inheritance-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_TABLE
    code: "42P07"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18039"
  - "postgres/src/backend/commands/tablecmds.c:21159"
reproduced: true
---

# `circular inheritance not allowed`

## What it means

A table-inheritance command would create a cycle — a table inheriting, directly or indirectly, from itself. Inheritance hierarchies must be acyclic, so the operation is rejected.

## When it happens

`CREATE TABLE ... INHERITS` or `ALTER TABLE ... INHERIT` that names a parent which is already a descendant of the table being defined.

## How to fix

Restructure the inheritance so the hierarchy forms a tree with no cycles. Remove the offending `INHERIT` relationship, or point the child at a parent that is not one of its own descendants.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
ALTER TABLE s36.inhparent INHERIT s36.inhchild;
```

Produces:

```text
ERROR:  circular inheritance not allowed
```

## Related

- [cannot inherit from partitioned table](./cannot-inherit-from-partitioned-table.md)
- [childrel is not a child of parentrel](./childrel-is-not-a-child-of-parentrel.md)
