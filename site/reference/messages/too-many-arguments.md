---
message: "too many arguments"
slug: too-many-arguments
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_ARGUMENTS
    code: "54023"
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:11424"
  - "postgres/src/backend/utils/adt/ruleutils.c:11637"
reproduced: false
---

# `too many arguments`

## What it means

A call or construct was given more arguments than it accepts. The exact limit depends on the context, but the number supplied exceeds what is allowed here.

## When it happens

It arises in several places — for example a function or construct with a fixed maximum argument count receiving too many, or a command form that accepts only a bounded list.

## How to fix

Reduce the number of arguments to what the target accepts. Check the function or command's documented signature and pass only the supported number.

## Example

*Illustrative* — a construct given too many arguments.

```text
ERROR:  too many arguments
```

## Related

- [too many function arguments](./too-many-function-arguments.md)
- [too few arguments for format()](./too-few-arguments-for-format.md)
