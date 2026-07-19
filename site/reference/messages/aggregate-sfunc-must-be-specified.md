---
message: "aggregate sfunc must be specified"
slug: aggregate-sfunc-must-be-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:204"
reproduced: false
---

# `aggregate sfunc must be specified`

## What it means

A `CREATE AGGREGATE` omitted the state transition function (`sfunc`), which is required to combine each input row into the aggregate's running state.

## When it happens

It occurs when the aggregate definition leaves out `sfunc`.

## How to fix

Add the `sfunc` clause naming the transition function. It, together with the state type, defines how the aggregate accumulates values.

## Example

*Illustrative* — a definition missing sfunc.

```text
ERROR:  aggregate sfunc must be specified
```

## Related

- [aggregate must have a transition function](./aggregate-must-have-a-transition-function.md)
- [aggregate stype must be specified](./aggregate-stype-must-be-specified.md)
