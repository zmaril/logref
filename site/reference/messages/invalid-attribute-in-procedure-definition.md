---
message: "invalid attribute in procedure definition"
slug: invalid-attribute-in-procedure-definition
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:612"
  - "postgres/src/backend/commands/functioncmds.c:791"
reproduced: false
---

# `invalid attribute in procedure definition`

## What it means

A `CREATE PROCEDURE` (or `ALTER PROCEDURE`) definition includes an attribute or clause that is not valid for procedures. Some function-only properties do not apply to procedures.

## When it happens

It arises when a procedure definition carries a clause that only functions accept — for example a volatility category, `RETURNS`, `LEAKPROOF`, `STRICT`, or a cost/rows estimate — none of which are meaningful for a procedure invoked by `CALL`.

## How to fix

Remove the function-only attributes from the procedure definition. Procedures do not return a value and do not carry volatility or planner-cost properties; keep only the clauses valid for `CREATE PROCEDURE`, such as language, `SECURITY`, and `SET`.

## Example

*Illustrative* — a volatility marker on a procedure.

```sql
CREATE PROCEDURE p() LANGUAGE sql IMMUTABLE AS $$ $$;  -- not valid for procedures
```

## Related

- [is not a procedure](./is-not-a-procedure.md)
- [only superuser can define a leakproof function](./only-superuser-can-define-a-leakproof-function.md)
