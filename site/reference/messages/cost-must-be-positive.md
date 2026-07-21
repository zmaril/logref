---
message: "COST must be positive"
slug: cost-must-be-positive
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:840"
  - "postgres/src/backend/commands/functioncmds.c:1446"
reproduced: true
---

# `COST must be positive`

## What it means

A `CREATE`/`ALTER FUNCTION` gave a `COST` value that is zero or negative. The planner uses `COST` as a positive estimate of execution expense, so it must be greater than zero.

## When it happens

Defining a function with `COST 0` or a negative cost, often from generated DDL or a copy-paste that lost the intended value.

## How to fix

Set `COST` to a positive number that reflects the function's relative expense (the default is 100 for most languages, 1 for C/internal). Use a realistic positive estimate so the planner costs calls sensibly.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
ALTER FUNCTION repro.altfn() COST -1;
```

Produces:

```text
ERROR:  COST must be positive
```

## Related

- [cannot change routine kind](./cannot-change-routine-kind.md)
- [could not find a function named](./could-not-find-a-function-named.md)
