---
message: "aggregate msfunc must be specified when mstype is specified"
slug: aggregate-msfunc-must-be-specified-when-mstype-is-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:216"
reproduced: true
---

# `aggregate msfunc must be specified when mstype is specified`

## What it means

A `CREATE AGGREGATE` defined a moving-aggregate state type (`mstype`) but did not provide the forward transition function (`msfunc`) that adds rows to the moving-aggregate state.

## When it happens

It occurs when the moving-aggregate mode names a state type without the forward transition function needed to maintain it.

## How to fix

Provide `msfunc` (and `minvfunc`) whenever you set `mstype`, or drop the moving-aggregate options. A moving-aggregate state type is useless without a forward transition function.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE AGGREGATE repro.agg_ms(int) (SFUNC = int4pl, STYPE = int, MSTYPE = int);
```

Produces:

```text
ERROR:  aggregate msfunc must be specified when mstype is specified
```

## Related

- [aggregate minvfunc must be specified when mstype is specified](./aggregate-minvfunc-must-be-specified-when-mstype-is-specified.md)
- [aggregate msfunc must not be specified without mstype](./aggregate-msfunc-must-not-be-specified-without-mstype.md)
