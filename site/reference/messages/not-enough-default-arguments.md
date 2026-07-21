---
message: "not enough default arguments"
slug: not-enough-default-arguments
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/clauses.c:5109"
  - "postgres/src/backend/parser/parse_func.c:1773"
reproduced: false
---

# `not enough default arguments`

## What it means

Internal error. Function-call code expected a set of default argument values but found fewer than the parameters that require them. It is a consistency guard over default-argument expansion.

## When it happens

It fires when resolving a call that omits trailing arguments and the stored defaults do not cover them — an inconsistency between a function's declared defaults and its call. Ordinary calls report a clearer arity error; reaching this guard points to catalog inconsistency or an internal bug.

## How to fix

This is a can't-happen guard for normal use. If a specific function triggers it, inspect its definition with `\df+` for damaged default metadata and consider recreating it. Capture the call and report a reproducible case.

## Example

*Illustrative* — defaults not covering the omitted arguments.

```text
ERROR:  not enough default arguments
```

## Related

- [invalid parameter mode](./invalid-parameter-mode.md)
- [no value found for parameter](./no-value-found-for-parameter.md)
