---
message: "aggregate input type must be specified"
slug: aggregate-input-type-must-be-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:272"
reproduced: false
---

# `aggregate input type must be specified`

## What it means

A `CREATE AGGREGATE` did not state the input (argument) type the aggregate accepts, which is required to define its signature.

## When it happens

It occurs when the aggregate definition omits the argument type list, so the server cannot tell what data the aggregate consumes.

## How to fix

Specify the aggregate's input type(s) in the definition, for example `CREATE AGGREGATE a(int) (...)`. Use `*` only for the special zero-argument form; otherwise name the argument types explicitly.

## Example

*Illustrative* — an aggregate with no input type.

```text
ERROR:  aggregate input type must be specified
```

## Related

- [aggregate stype must be specified](./aggregate-stype-must-be-specified.md)
- [aggregate sfunc must be specified](./aggregate-sfunc-must-be-specified.md)
