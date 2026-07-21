---
message: "cannot use table references in parameter default value"
slug: cannot-use-table-references-in-parameter-default-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:433"
reproduced: false
---

# `cannot use table references in parameter default value`

## What it means

A function or procedure parameter default referenced a table column. Parameter defaults are evaluated without a row context at call time, so they cannot read from a table.

## When it happens

It occurs on `CREATE FUNCTION` or `CREATE PROCEDURE` when a parameter's `DEFAULT` expression names a table column.

## How to fix

Use a constant or a context-free expression for the default. If the default must come from a table, drop the parameter default and look the value up inside the function body.

## Example

*Illustrative* — a table reference in a parameter default.

```sql
CREATE FUNCTION f(x int DEFAULT (SELECT max(id) FROM t)) ...;
-- ERROR:  cannot use table references in parameter default value
```

## Related

- [cannot use table references in domain check constraint](./cannot-use-table-references-in-domain-check-constraint.md)
- [cannot use RETURN NEXT in a non-SETOF function](./cannot-use-return-next-in-a-non-setof-function.md)
