---
message: "cannot use table references in domain check constraint"
slug: cannot-use-table-references-in-domain-check-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3617"
reproduced: false
---

# `cannot use table references in domain check constraint`

## What it means

A domain's `CHECK` constraint referenced a table column. A domain constraint applies to a single value through the special `VALUE` keyword and has no row context, so it cannot read from a table.

## When it happens

It occurs on `CREATE DOMAIN ... CHECK (...)` or `ALTER DOMAIN ... ADD CHECK (...)` when the expression names a table column instead of `VALUE`.

## How to fix

Write the domain check in terms of `VALUE` only. If the rule needs to consult a table, enforce it with a table-level constraint or trigger rather than a domain constraint.

## Example

*Illustrative* — a table reference in a domain check.

```sql
CREATE DOMAIN d AS int CHECK (VALUE IN (SELECT id FROM ref));
-- ERROR:  cannot use table references in domain check constraint
```

## Related

- [cannot use table references in parameter default value](./cannot-use-table-references-in-parameter-default-value.md)
- [cannot use system column in column generation expression](./cannot-use-system-column-in-column-generation-expression.md)
