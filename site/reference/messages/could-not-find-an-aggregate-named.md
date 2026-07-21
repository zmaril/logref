---
message: "could not find an aggregate named \"%s\""
slug: could-not-find-an-aggregate-named
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:2550"
reproduced: false
---

# `could not find an aggregate named "%s"`

## What it means

A command referenced an aggregate by name that does not exist. The `%s` gives the name. No aggregate of that name (and matching arguments) was found in the search path.

## When it happens

It happens with commands that target an aggregate specifically — such as `ALTER AGGREGATE` or `DROP AGGREGATE` — when the named aggregate is absent or the name and argument types do not match one.

## How to fix

Check the aggregate name, argument types, and schema. A plain function of that name does not satisfy an aggregate-specific command — confirm the object is an aggregate. Qualify the name with its schema if needed.

## Example

*Illustrative* — an aggregate name with no match.

```sql
DROP AGGREGATE nonexistent_agg(int);
-- ERROR:  could not find an aggregate named "nonexistent_agg"
```

## Related

- [could not find a procedure named](./could-not-find-a-procedure-named.md)
- [could not find function information for function](./could-not-find-function-information-for-function.md)
