---
message: "aggregate minvfunc must be specified when mstype is specified"
slug: aggregate-minvfunc-must-be-specified-when-mstype-is-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:220"
reproduced: false
---

# `aggregate minvfunc must be specified when mstype is specified`

## What it means

A `CREATE AGGREGATE` defined a moving-aggregate state type (`mstype`) but did not provide the inverse transition function (`minvfunc`) that moving aggregation requires to remove rows leaving the window frame.

## When it happens

It occurs when the moving-aggregate mode is partly defined: `mstype` is present but the inverse function needed to support sliding window frames is missing.

## How to fix

Provide `minvfunc` (the inverse transition function) alongside `mstype` and `msfunc`, or drop the moving-aggregate options entirely. Moving aggregation needs both a forward and an inverse transition function.

## Example

*Illustrative* — mstype without its inverse function.

```text
ERROR:  aggregate minvfunc must be specified when mstype is specified
```

## Related

- [aggregate msfunc must be specified when mstype is specified](./aggregate-msfunc-must-be-specified-when-mstype-is-specified.md)
- [aggregate minvfunc must not be specified without mstype](./aggregate-minvfunc-must-not-be-specified-without-mstype.md)
