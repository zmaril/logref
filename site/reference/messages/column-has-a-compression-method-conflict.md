---
message: "column \"%s\" has a compression method conflict"
slug: column-has-a-compression-method-conflict
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3403"
  - "postgres/src/backend/commands/tablecmds.c:3563"
reproduced: false
---

# `column "%s" has a compression method conflict`

## What it means

During inheritance or partition merging, a column inherited from multiple parents with conflicting compression methods, or a child specified a compression method inconsistent with its parent. The placeholder is the column name. A merged column must resolve to a single compression setting.

## When it happens

Creating a table that inherits the same column from several parents that set different `COMPRESSION` methods, or attaching a child whose column compression disagrees with the parent.

## How to fix

Make the compression method consistent across the parents and the child for the shared column — set the same `COMPRESSION` (or leave it default) everywhere the column is inherited. Reconcile the conflicting definitions before creating or attaching.

## Example

*Illustrative* — conflicting inherited compression.

```text
ERROR:  column "body" has a compression method conflict
```

## Related

- [column is of type but default expression is of type](./column-is-of-type-but-default-expression-is-of-type.md)
- [child table has different type for column](./child-table-has-different-type-for-column.md)
