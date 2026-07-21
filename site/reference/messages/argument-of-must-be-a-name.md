---
message: "argument of %s must be a name"
slug: argument-of-must-be-a-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/define.c:255"
reproduced: false
---

# `argument of %s must be a name`

## What it means

A construct that requires a bare identifier (a name) in a particular argument position was given something that is not a name, such as an expression or a qualified reference.

## When it happens

It occurs in commands and clauses whose grammar expects a plain name where a more complex value was supplied.

## How to fix

Supply a simple identifier in that position, following the construct's syntax. Remove qualification, quoting problems, or expressions where only a name is allowed. Check the documentation for the exact form the clause expects.

## Example

*Illustrative* — a non-name where a name is required.

```text
ERROR:  argument of CONSTRAINT must be a name
```

## Related

- [argument of must be a type name](./argument-of-must-be-a-type-name.md)
- [argument name used more than once](./argument-name-used-more-than-once.md)
