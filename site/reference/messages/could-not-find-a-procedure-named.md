---
message: "could not find a procedure named \"%s\""
slug: could-not-find-a-procedure-named
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:2536"
reproduced: false
---

# `could not find a procedure named "%s"`

## What it means

A command referenced a procedure by name that does not exist. The `%s` gives the name. No procedure of that name (and matching arguments) was found in the search path.

## When it happens

It happens with statements that target a procedure specifically — such as `ALTER PROCEDURE`, `DROP PROCEDURE`, or `CALL` — when the named procedure is absent or the name and argument types do not match one.

## How to fix

Check the procedure name, argument types, and schema. A function of that name does not satisfy a procedure-specific command — confirm the object is a procedure. Qualify the name with its schema if the search path does not include it.

## Example

*Illustrative* — a procedure name with no match.

```sql
DROP PROCEDURE nonexistent_proc();
-- ERROR:  could not find a procedure named "nonexistent_proc"
```

## Related

- [could not find an aggregate named](./could-not-find-an-aggregate-named.md)
- [could not find function information for function](./could-not-find-function-information-for-function.md)
