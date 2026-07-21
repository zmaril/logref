---
message: "statistics target %d is too low"
slug: statistics-target-is-too-low
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:696"
  - "postgres/src/backend/commands/tablecmds.c:9082"
reproduced: true
---

# `statistics target %d is too low`

## What it means

A statistics target value was set below the minimum allowed. The placeholder is the value. The statistics target controls how much detail `ANALYZE` collects, and it has a lower bound.

## When it happens

It arises from `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS n` or the `default_statistics_target` GUC with a value below the permitted minimum (values of `-1` to reset, or within the valid range, are accepted).

## How to fix

Use a value within the allowed range (the minimum is small but positive; the special value `-1` resets a column to the default). Choose a higher target for columns whose distribution the planner needs to model in detail.

## Example

*Reproduced* — captured from `reproducers/scenarios/27_alter_table.sql`.

```sql
ALTER TABLE repro.at ALTER COLUMN a SET STATISTICS -5;
```

Produces:

```text
ERROR:  statistics target -5 is too low
```

## Related

- [ROWS must be positive](./rows-must-be-positive.md)
- [step size cannot be infinite](./step-size-cannot-be-infinite.md)
