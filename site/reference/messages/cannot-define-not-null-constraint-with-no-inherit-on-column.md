---
message: "cannot define not-null constraint with NO INHERIT on column \"%s\""
slug: cannot-define-not-null-constraint-with-no-inherit-on-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/catalog/heap.c:3030"
reproduced: false
---

# `cannot define not-null constraint with NO INHERIT on column "%s"`

## What it means

A `NOT NULL` constraint was declared `NO INHERIT` on a column, which is not allowed. Not-null constraints on a table always apply to inheritance and partition children, so they cannot be marked non-inheritable. The placeholder is the column name.

## When it happens

It occurs when a column's not-null constraint is written with the `NO INHERIT` clause.

## How to fix

Remove `NO INHERIT` from the not-null constraint. Not-null constraints are inherited by design; if you need child-specific nullability, model it differently.

## Example

*Illustrative* — NO INHERIT on a not-null constraint.

```text
ERROR:  cannot define not-null constraint with NO INHERIT on column "x"
```

## Related

- [cannot create not-null constraint on column of table](./cannot-create-not-null-constraint-on-column-of-table.md)
- [cannot drop generation expression from inherited column](./cannot-drop-generation-expression-from-inherited-column.md)
