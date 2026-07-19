---
message: "cannot alter type of a column used by a view or rule"
slug: cannot-alter-type-of-a-column-used-by-a-view-or-rule
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15679"
reproduced: false
---

# `cannot alter type of a column used by a view or rule`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` was blocked because a view or rewrite rule reads the column. The view or rule's definition depends on the column's current type.

## When it happens

It occurs when the column being retyped is referenced by a view's `SELECT`, or by a rule attached to the table.

## How to fix

Drop the dependent view or rule, alter the column type, then recreate the view or rule against the new type. Postgres will not silently rewrite a view whose column types change under it.

## Example

*Illustrative* — a column referenced by a view.

```text
ERROR:  cannot alter type of a column used by a view or rule
```

## Related

- [cannot alter type of a column used by a generated column](./cannot-alter-type-of-a-column-used-by-a-generated-column.md)
- [cannot change data type of view column from to](./cannot-change-data-type-of-view-column-from-to.md)
