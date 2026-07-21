---
message: "child table \"%s\" has different collation for column \"%s\""
slug: child-table-has-different-collation-for-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_COLLATION_MISMATCH
    code: "42P21"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7424"
  - "postgres/src/backend/commands/tablecmds.c:18240"
reproduced: false
---

# `child table "%s" has different collation for column "%s"`

## What it means

During inheritance or partition setup, a child table's column has a different collation than the parent's matching column. The placeholders are the child table and the column. Inherited columns must share the parent's collation so comparisons behave consistently across the hierarchy.

## When it happens

Creating a child table (via `INHERITS` or `ATTACH PARTITION`) whose column was declared with a `COLLATE` that differs from the parent's column collation.

## How to fix

Declare the child column with the same collation as the parent, or drop the explicit `COLLATE` so it inherits. Align every inherited column's collation with the parent before attaching or creating the child.

## Example

*Illustrative* — mismatched collation on a child column.

```text
ERROR:  child table "c" has different collation for column "name"
```

## Related

- [child table has different type for column](./child-table-has-different-type-for-column.md)
- [child table has different definition for check constraint](./child-table-has-different-definition-for-check-constraint.md)
