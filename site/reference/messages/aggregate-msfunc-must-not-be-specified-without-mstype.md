---
message: "aggregate msfunc must not be specified without mstype"
slug: aggregate-msfunc-must-not-be-specified-without-mstype
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:227"
reproduced: false
---

# `aggregate msfunc must not be specified without mstype`

## What it means

A `CREATE AGGREGATE` supplied a moving-aggregate forward function (`msfunc`) without defining the moving-aggregate state type (`mstype`) it maintains.

## When it happens

It occurs when a moving-aggregate forward transition function is given but the moving-aggregate state type is missing.

## How to fix

Add `mstype` (and `minvfunc`) so the forward function has a state to maintain, or remove `msfunc` if you are not defining moving-aggregate support.

## Example

*Illustrative* — msfunc without mstype.

```text
ERROR:  aggregate msfunc must not be specified without mstype
```

## Related

- [aggregate msfunc must be specified when mstype is specified](./aggregate-msfunc-must-be-specified-when-mstype-is-specified.md)
- [aggregate msspace must not be specified without mstype](./aggregate-msspace-must-not-be-specified-without-mstype.md)
