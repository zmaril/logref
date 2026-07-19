---
message: "arguments required for cursor"
slug: arguments-required-for-cursor
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2968"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4873"
reproduced: false
---

# `arguments required for cursor`

## What it means

A cursor declared with parameters was opened without supplying them. The cursor's query references its parameters, so it cannot be opened until values are provided for them.

## When it happens

In PL/pgSQL, opening a parameterized cursor with `OPEN cur` and no argument list, when `cur` was declared with parameters, or iterating over it without passing arguments.

## How to fix

Open the cursor with its arguments, for example `OPEN cur(value1, value2)`, providing a value for each declared parameter. Match the number and order of arguments to the cursor's declaration.

## Example

*Illustrative* — opening a parameterized cursor with no arguments.

```sql
OPEN c;  -- cursor c requires arguments
```

## Related

- [arguments given for cursor without arguments](./arguments-given-for-cursor-without-arguments.md)
- [cannot open multi query plan as cursor](./cannot-open-multi-query-plan-as-cursor.md)
