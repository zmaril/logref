---
message: "duplicate function body specified"
slug: duplicate-function-body-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:882"
reproduced: false
---

# `duplicate function body specified`

## What it means

A `CREATE FUNCTION` specified the function body more than once — for example both an `AS` clause and a SQL-standard `BEGIN ATOMIC ... END` body, or two conflicting body clauses.

## When it happens

It fires from `CREATE FUNCTION`/`CREATE PROCEDURE` when the definition gives the body in two ways at once.

## How to fix

Specify the body exactly once. Use either the `AS 'source'` form or the SQL-standard `BEGIN ATOMIC ... END` form, not both, and do not repeat the `AS` clause.

## Example

*Illustrative* — two bodies in one definition.

```sql
CREATE FUNCTION f() RETURNS int LANGUAGE sql
  AS 'SELECT 1'
  BEGIN ATOMIC SELECT 1; END;
-- duplicate function body specified
```

## Related

- [encoding conversion function must return type](./encoding-conversion-function-must-return-type.md)
- [element type cannot be specified without a subscripting function](./element-type-cannot-be-specified-without-a-subscripting-function.md)
