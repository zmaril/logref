---
message: "\"%s\" is an aggregate function"
slug: is-an-aggregate-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/dropcmds.c:94"
  - "postgres/src/backend/commands/functioncmds.c:1401"
  - "postgres/src/backend/utils/adt/ruleutils.c:3314"
reproduced: true
---

# `"%s" is an aggregate function`

## What it means

A command referenced a routine expecting a plain function, but the name resolves to an aggregate function. Aggregates are defined and dropped through aggregate-specific commands and cannot be treated as ordinary functions.

## When it happens

Running `DROP FUNCTION`, `ALTER FUNCTION`, or another function-only command against the name of an aggregate, or referencing an aggregate where a scalar function was expected.

## How to fix

Use the aggregate-specific command form — `DROP AGGREGATE`, `ALTER AGGREGATE` — for aggregates. If you did not mean the aggregate, check the name, since an aggregate and a regular function can share a name but differ in how they are managed.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
ALTER FUNCTION repro.agg_amb(int) STRICT;
```

Produces:

```text
ERROR:  "repro.agg_amb" is an aggregate function
```

## Related

- [function is not an aggregate](./function-is-not-an-aggregate.md)
- [aggregate order by is not implemented for window functions](./aggregate-order-by-is-not-implemented-for-window-functions.md)
