---
message: "aggregate msspace must not be specified without mstype"
slug: aggregate-msspace-must-not-be-specified-without-mstype
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:239"
reproduced: false
---

# `aggregate msspace must not be specified without mstype`

## What it means

A `CREATE AGGREGATE` supplied a moving-aggregate state-size estimate (`msspace`) without defining the moving-aggregate state type (`mstype`) it describes.

## When it happens

It occurs when the moving-aggregate space hint is given but the moving-aggregate state type is missing from the definition.

## How to fix

Add `mstype` (with its transition functions) so the space estimate applies to an actual moving-aggregate state, or remove `msspace` if you are not defining moving-aggregate support.

## Example

*Illustrative* — msspace without mstype.

```text
ERROR:  aggregate msspace must not be specified without mstype
```

## Related

- [aggregate minitcond must not be specified without mstype](./aggregate-minitcond-must-not-be-specified-without-mstype.md)
- [aggregate msfunc must not be specified without mstype](./aggregate-msfunc-must-not-be-specified-without-mstype.md)
