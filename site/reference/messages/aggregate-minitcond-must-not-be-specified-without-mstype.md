---
message: "aggregate minitcond must not be specified without mstype"
slug: aggregate-minitcond-must-not-be-specified-without-mstype
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:243"
reproduced: false
---

# `aggregate minitcond must not be specified without mstype`

## What it means

A `CREATE AGGREGATE` supplied a moving-aggregate initial condition (`minitcond`) without defining the moving-aggregate state type (`mstype`) it initializes.

## When it happens

It occurs when a moving-aggregate initial value is given but the moving-aggregate state type is missing from the definition.

## How to fix

Add the `mstype` (and its transition functions) so the initial condition has a state to initialize, or remove `minitcond` if you are not defining a moving-aggregate mode.

## Example

*Illustrative* — minitcond without mstype.

```text
ERROR:  aggregate minitcond must not be specified without mstype
```

## Related

- [aggregate mfinalfunc must not be specified without mstype](./aggregate-mfinalfunc-must-not-be-specified-without-mstype.md)
- [aggregate msspace must not be specified without mstype](./aggregate-msspace-must-not-be-specified-without-mstype.md)
