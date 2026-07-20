---
message: "aggregate stype must be specified"
slug: aggregate-stype-must-be-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:200"
reproduced: false
---

# `aggregate stype must be specified`

## What it means

A `CREATE AGGREGATE` omitted the state (transition) data type (`stype`), which is required so the server knows what type the accumulated value has.

## When it happens

It occurs when the aggregate definition leaves out `stype`.

## How to fix

Add the `stype` clause naming the transition state type. The transition function reads and returns this type as it folds in each row.

## Example

*Illustrative* — a definition missing stype.

```text
ERROR:  aggregate stype must be specified
```

## Related

- [aggregate sfunc must be specified](./aggregate-sfunc-must-be-specified.md)
- [aggregate input type must be specified](./aggregate-input-type-must-be-specified.md)
