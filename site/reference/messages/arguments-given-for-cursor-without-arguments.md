---
message: "arguments given for cursor without arguments"
slug: arguments-given-for-cursor-without-arguments
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2949"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4854"
reproduced: false
---

# `arguments given for cursor without arguments`

## What it means

A cursor that was declared without parameters was opened with an argument list. The cursor takes no arguments, so supplying any is a mismatch between the declaration and the open.

## When it happens

In PL/pgSQL, opening a bound cursor with `OPEN cur(...)` when `cur` was declared with no parameter list, or using a `FOR ... IN cur(...)` loop over an argument-less cursor.

## How to fix

Open the cursor without arguments, matching its declaration, or add the intended parameters to the cursor's `DECLARE` if it should take some. The number and presence of arguments at open must match the cursor's declared parameters.

## Example

*Illustrative* — arguments passed to a parameterless cursor.

```sql
OPEN c(1);  -- cursor c was declared without arguments
```

## Related

- [arguments required for cursor](./arguments-required-for-cursor.md)
- [cannot open multi query plan as cursor](./cannot-open-multi-query-plan-as-cursor.md)
