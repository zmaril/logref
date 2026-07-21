---
message: "cast function must not return a set"
slug: cast-function-must-not-return-a-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:1667"
reproduced: true
---

# `cast function must not return a set`

## What it means

A `CREATE CAST ... WITH FUNCTION` named a set-returning function. A cast converts one value to one value, so its function must return a single result, not a set.

## When it happens

It occurs on `CREATE CAST` when the referenced function is declared `RETURNS SETOF` or `RETURNS TABLE`.

## How to fix

Use a function that returns a single value of the target type. Rewrite the conversion so it yields one result per input.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE CAST (int AS int) WITH FUNCTION generate_series(int, int);
```

Produces:

```text
ERROR:  cast function must not return a set
```

## Related

- [cast function must be a normal function](./cast-function-must-be-a-normal-function.md)
- [cast function must take one to three arguments](./cast-function-must-take-one-to-three-arguments.md)
