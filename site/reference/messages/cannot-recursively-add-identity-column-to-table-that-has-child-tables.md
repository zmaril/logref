---
message: "cannot recursively add identity column to table that has child tables"
slug: cannot-recursively-add-identity-column-to-table-that-has-child-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7495"
reproduced: false
---

# `cannot recursively add identity column to table that has child tables`

## What it means

An `ALTER TABLE ... ADD COLUMN ... GENERATED ... AS IDENTITY` was blocked because the table has inheritance children. An identity column cannot be added recursively to a table that already has child tables, since the identity sequence would not be well-defined across the hierarchy.

## When it happens

It occurs when you add an identity column to a parent table in an inheritance hierarchy.

## How to fix

Add the identity column with `ONLY` on the parent where the semantics allow, or restructure so the identity column is defined before children are attached. Consider whether the hierarchy needs a shared identity at all.

## Example

*Illustrative* — adding an identity column to a parent with children.

```text
ERROR:  cannot recursively add identity column to table that has child tables
```

## Related

- [cannot rename inherited column](./cannot-rename-inherited-column.md)
- [cannot rename inherited constraint](./cannot-rename-inherited-constraint.md)
