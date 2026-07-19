---
message: "referenced relation \"%s\" is not a table"
slug: referenced-relation-is-not-a-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10252"
  - "postgres/src/backend/commands/tablecmds.c:10891"
reproduced: false
---

# `referenced relation "%s" is not a table`

## What it means

A foreign key or similar reference named a relation that is not an ordinary table (for example a view, or another kind of relation that cannot be the target of the reference). The placeholder is the relation name. The referenced side of a foreign key must be a table.

## When it happens

It arises from `CREATE TABLE`/`ALTER TABLE ... REFERENCES` (or an equivalent) that points at a view, a foreign table, or another non-table relation as the referenced object.

## How to fix

Reference an actual table (with a unique or primary-key constraint on the referenced columns). If the target is a view, reference the underlying table instead; foreign keys cannot target views or other non-table relations.

## Example

*Illustrative* — a foreign key referencing a view.

```text
ERROR:  referenced relation "orders_view" is not a table
```

## Related

- [relation "%s" is of wrong relation kind](./relation-is-of-wrong-relation-kind.md)
- [primary key constraints are not supported on foreign tables](./primary-key-constraints-are-not-supported-on-foreign-tables.md)
