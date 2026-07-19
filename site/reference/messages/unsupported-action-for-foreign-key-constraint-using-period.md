---
message: "unsupported %s action for foreign key constraint using PERIOD"
slug: unsupported-action-for-foreign-key-constraint-using-period
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10432"
  - "postgres/src/backend/commands/tablecmds.c:10441"
reproduced: false
---

# `unsupported %s action for foreign key constraint using PERIOD`

## What it means

A temporal foreign key defined with a `PERIOD` column was given a referential action (`ON DELETE`/`ON UPDATE`) that the temporal-foreign-key feature does not yet support.

## When it happens

It arises from `CREATE TABLE`/`ALTER TABLE` defining a `FOREIGN KEY ... PERIOD ...` constraint with an action such as `SET NULL` or `SET DEFAULT` that the temporal implementation does not implement.

## How to fix

Use a supported action for the temporal foreign key — typically `NO ACTION`, `RESTRICT`, or `CASCADE` where available. Remove the unsupported action, or enforce the intended behavior with an explicit trigger.

## Example

*Illustrative* — an unsupported action on a PERIOD foreign key.

```text
ERROR:  unsupported SET NULL action for foreign key constraint using PERIOD
```

## Related

- [unique constraints are not supported on foreign tables](./unique-constraints-are-not-supported-on-foreign-tables.md)
- [unrecognized FK action type: %d](./unrecognized-fk-action-type.md)
