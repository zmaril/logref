---
message: "aggregate mfinalfunc must not be specified without mstype"
slug: aggregate-mfinalfunc-must-not-be-specified-without-mstype
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:235"
reproduced: false
---

# `aggregate mfinalfunc must not be specified without mstype`

## What it means

A `CREATE AGGREGATE` supplied a moving-aggregate final function (`mfinalfunc`) but did not define the moving-aggregate state type (`mstype`) it belongs to, so the setting has no state to operate on.

## When it happens

It occurs when defining an aggregate with moving-aggregate (window frame) support where one moving-aggregate option is given without the required `mstype`.

## How to fix

Either add the `mstype` (and the rest of the moving-aggregate implementation) so the moving final function has a state to finalize, or remove `mfinalfunc` if you do not want a separate moving-aggregate mode.

## Example

*Illustrative* — mfinalfunc without mstype.

```text
ERROR:  aggregate mfinalfunc must not be specified without mstype
```

## Related

- [aggregate minvfunc must not be specified without mstype](./aggregate-minvfunc-must-not-be-specified-without-mstype.md)
- [aggregate msfunc must be specified when mstype is specified](./aggregate-msfunc-must-be-specified-when-mstype-is-specified.md)
