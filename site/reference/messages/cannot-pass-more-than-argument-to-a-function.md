---
message: "cannot pass more than %d argument to a function"
slug: cannot-pass-more-than-argument-to-a-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_ARGUMENTS
    code: "54023"
call_sites:
  - "postgres/src/backend/executor/execExpr.c:2720"
  - "postgres/src/backend/executor/execSRF.c:718"
  - "postgres/src/backend/parser/parse_func.c:140"
  - "postgres/src/backend/parser/parse_func.c:673"
  - "postgres/src/backend/parser/parse_func.c:1152"
reproduced: false
---

# `cannot pass more than %d argument to a function`

## What it means

A function call resolved to more arguments than Postgres allows. The placeholder is the maximum (the build-time `FUNC_MAX_ARGS`, 100 by default). This is checked at execution, notably when a `VARIADIC` array expands into more elements than the limit permits.

## When it happens

Calling a variadic function with a `VARIADIC` array whose length pushes the total argument count over the limit, or otherwise constructing a call with too many arguments.

## How to fix

Reduce the number of arguments below the limit. For variadic calls, split the work into batches that each stay under `FUNC_MAX_ARGS`, or aggregate the values a different way (for example pass an array and process it inside the function). The limit is fixed at compile time and not tunable at runtime.

## Example

*Illustrative* — a variadic expansion over the limit.

```text
ERROR:  cannot pass more than 100 argument to a function
```

## Related

- [requested length too large](./requested-length-too-large.md)
- [there is no parameter](./there-is-no-parameter.md)
