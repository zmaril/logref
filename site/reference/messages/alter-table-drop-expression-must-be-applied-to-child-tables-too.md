---
message: "ALTER TABLE / DROP EXPRESSION must be applied to child tables too"
slug: alter-table-drop-expression-must-be-applied-to-child-tables-too
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8905"
reproduced: false
---

# `ALTER TABLE / DROP EXPRESSION must be applied to child tables too`

## What it means

An `ALTER TABLE ... DROP EXPRESSION` was run with a form that does not cascade to inheritance or partition children, but the generated column exists on child tables that also need the change.

## When it happens

It occurs when dropping a generated-column expression on an inheritance parent or partitioned table using `ONLY`, or in a way that would leave children inconsistent.

## How to fix

Apply the change so it reaches the children — omit `ONLY` so the alter recurses to child tables, or run the equivalent on each child. Inherited and partitioned generated columns must be kept consistent across the hierarchy.

## Example

*Illustrative* — dropping an expression without recursing to children.

```sql
ALTER TABLE ONLY parent ALTER COLUMN g DROP EXPRESSION;  -- must apply to children too
```

## Related

- [alter table / drop expression is not supported for virtual generated columns](./alter-table-drop-expression-is-not-supported-for-virtual-generated-columns.md)
- [alter table add constraint using index is not supported on partitioned tables](./alter-table-add-constraint-using-index-is-not-supported-on-partitioned-tables.md)
