---
message: "argument of %s must be a type name"
slug: argument-of-must-be-a-type-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/define.c:285"
reproduced: false
---

# `argument of %s must be a type name`

## What it means

A construct that requires a type name in a particular argument position was given something that is not a type name.

## When it happens

It occurs in commands and clauses whose grammar expects a data type where a different kind of token or expression was supplied.

## How to fix

Provide a valid type name in that position (for example `integer`, `text`, or a schema-qualified type). Check that the type exists and is spelled correctly, and follow the clause's expected syntax.

## Example

*Illustrative* — a non-type where a type name is required.

```text
ERROR:  argument of CAST must be a type name
```

## Related

- [argument of must be a name](./argument-of-must-be-a-name.md)
- [array element type cannot be](./array-element-type-cannot-be.md)
