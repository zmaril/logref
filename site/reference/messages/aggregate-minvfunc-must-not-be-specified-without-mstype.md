---
message: "aggregate minvfunc must not be specified without mstype"
slug: aggregate-minvfunc-must-not-be-specified-without-mstype
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:231"
reproduced: true
---

# `aggregate minvfunc must not be specified without mstype`

## What it means

A `CREATE AGGREGATE` supplied a moving-aggregate inverse function (`minvfunc`) without defining the moving-aggregate state type (`mstype`) it operates on.

## When it happens

It occurs when a moving-aggregate inverse function is given but the moving-aggregate state type is missing from the definition.

## How to fix

Add `mstype` (and the forward `msfunc`) so the inverse function has a moving-aggregate state to work with, or remove `minvfunc` if you are not defining moving-aggregate support.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE AGGREGATE repro.agg_minv(int) (SFUNC = int4pl, STYPE = int, MINVFUNC = int4mi);
```

Produces:

```text
ERROR:  aggregate minvfunc must not be specified without mstype
```

## Related

- [aggregate minvfunc must be specified when mstype is specified](./aggregate-minvfunc-must-be-specified-when-mstype-is-specified.md)
- [aggregate mfinalfunc must not be specified without mstype](./aggregate-mfinalfunc-must-not-be-specified-without-mstype.md)
