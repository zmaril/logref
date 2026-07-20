---
message: "cannot merge into column \"%s\" of view \"%s\""
slug: cannot-merge-into-column-of-view
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:3469"
reproduced: false
---

# `cannot merge into column "%s" of view "%s"`

## What it means

A `MERGE` statement targeted a view column that is not writable. The column maps to an expression or a non-updatable part of the view, so `MERGE` cannot apply changes to it. The placeholders are the column and view names.

## When it happens

It occurs when a `MERGE` runs against an auto-updatable view and names a column whose definition is computed or otherwise not writable.

## How to fix

Merge only into columns that map to base-table columns, or add `INSTEAD OF` triggers to the view to define how merges should be applied. Where possible, run the `MERGE` against the base table.

## Example

*Illustrative* — MERGE into a computed view column.

```text
ERROR:  cannot merge into column "full_name" of view "v_people"
```

## Related

- [cannot merge into view](./cannot-merge-into-view.md)
- [cannot insert into column of view](./cannot-insert-into-column-of-view.md)
