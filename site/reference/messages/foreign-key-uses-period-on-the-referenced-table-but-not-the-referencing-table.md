---
message: "foreign key uses PERIOD on the referenced table but not the referencing table"
slug: foreign-key-uses-period-on-the-referenced-table-but-not-the-referencing-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FOREIGN_KEY
    code: "42830"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10319"
  - "postgres/src/backend/commands/tablecmds.c:10347"
reproduced: false
---

# `foreign key uses PERIOD on the referenced table but not the referencing table`

## What it means

A temporal foreign key used `PERIOD` on the referenced side but not on the referencing side. A temporal foreign key must apply `PERIOD` consistently on both tables.

## When it happens

Defining a temporal (`PERIOD`) foreign key where only the referenced-table column list uses `PERIOD`, and the referencing side omits it.

## How to fix

Add `PERIOD` to the referencing side's column list to match the referenced side, so the temporal foreign key is symmetric.

## Example

*Illustrative* — PERIOD only on the referenced side.

```text
ERROR:  foreign key uses PERIOD on the referenced table but not the referencing table
```

## Related

- [foreign key constraint cannot be implemented](./foreign-key-constraint-cannot-be-implemented.md)
- [empty range bound specified for partition](./empty-range-bound-specified-for-partition.md)
