---
message: "cannot insert a non-DEFAULT value into column \"%s\""
slug: cannot-insert-a-non-default-value-into-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_GENERATED_ALWAYS
    code: "428C9"
call_sites:
  - "postgres/src/backend/rewrite/rewriteHandler.c:957"
  - "postgres/src/backend/rewrite/rewriteHandler.c:997"
reproduced: false
---

# `cannot insert a non-DEFAULT value into column "%s"`

## What it means

An `INSERT` or `UPDATE` supplied an explicit value for a column defined as `GENERATED ALWAYS AS IDENTITY` (or a generated column) where only `DEFAULT` is permitted. The placeholder is the column name. Such a column's value is produced by the system, not by the statement.

## When it happens

Writing an explicit value into a `GENERATED ALWAYS AS IDENTITY` column without `OVERRIDING SYSTEM VALUE`, or into a generated column, in an `INSERT`/`UPDATE`.

## How to fix

Omit the column, or write `DEFAULT` for it, so the system supplies the value. If you genuinely must insert a specific identity value, add `OVERRIDING SYSTEM VALUE` to the `INSERT`. For a generated column, the value is always computed and cannot be set.

## Example

*Illustrative* — an explicit value for a GENERATED ALWAYS identity.

```sql
INSERT INTO t (id, name) VALUES (5, 'x');  -- id is GENERATED ALWAYS AS IDENTITY
-- ERROR:  cannot insert a non-DEFAULT value into column "id"
```

## Related

- [column can only be updated to DEFAULT](./column-can-only-be-updated-to-default.md)
- [cannot set generated column](./cannot-set-generated-column.md)
