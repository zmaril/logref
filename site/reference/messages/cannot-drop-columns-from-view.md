---
message: "cannot drop columns from view"
slug: cannot-drop-columns-from-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/view.c:271"
  - "postgres/src/backend/commands/view.c:282"
reproduced: false
---

# `cannot drop columns from view`

## What it means

A `CREATE OR REPLACE VIEW` tried to remove one or more columns that the existing view already has. Replacing a view may add columns at the end but may not drop or reorder the existing ones, because dependents rely on the established column set.

## When it happens

Running `CREATE OR REPLACE VIEW` with a new query that produces fewer columns, or drops a column that the current view definition exposes.

## How to fix

Keep all existing columns (you may append new ones at the end), or `DROP VIEW` and recreate it if you truly need to remove columns — dropping any dependent objects first. `CREATE OR REPLACE` cannot shrink a view's column list.

## Example

*Illustrative* — replacing a view with fewer columns.

```text
ERROR:  cannot drop columns from view
```

## Related

- [cannot update column of view](./cannot-update-column-of-view.md)
- [cannot drop because requires it](./cannot-drop-because-requires-it.md)
