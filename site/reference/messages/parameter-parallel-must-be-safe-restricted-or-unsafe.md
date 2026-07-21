---
message: "parameter \"parallel\" must be SAFE, RESTRICTED, or UNSAFE"
slug: parameter-parallel-must-be-safe-restricted-or-unsafe
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:432"
  - "postgres/src/backend/commands/functioncmds.c:650"
reproduced: true
---

# `parameter "parallel" must be SAFE, RESTRICTED, or UNSAFE`

## What it means

A function definition set the `PARALLEL` property to a value other than the three allowed keywords. The parallel-safety marking must be exactly `SAFE`, `RESTRICTED`, or `UNSAFE`.

## When it happens

It arises from `CREATE FUNCTION` or `ALTER FUNCTION ... PARALLEL x` when `x` is misspelled or is not one of the three legal values.

## How to fix

Use one of `PARALLEL SAFE`, `PARALLEL RESTRICTED`, or `PARALLEL UNSAFE`. Choose based on whether the function can run in parallel workers safely; when unsure, `UNSAFE` (the default) is the conservative choice.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE AGGREGATE repro.agg_par(int) (SFUNC = int4pl, STYPE = int, PARALLEL = bogus);
```

Produces:

```text
ERROR:  parameter "parallel" must be SAFE, RESTRICTED, or UNSAFE
```

## Related

- [parameter name "%s" used more than once](./parameter-name-used-more-than-once.md)
- [ROWS is not applicable when function does not return a set](./rows-is-not-applicable-when-function-does-not-return-a-set.md)
