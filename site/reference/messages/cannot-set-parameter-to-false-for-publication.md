---
message: "cannot set parameter \"%s\" to false for publication \"%s\""
slug: cannot-set-parameter-to-false-for-publication
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1113"
  - "postgres/src/backend/commands/publicationcmds.c:1121"
reproduced: false
---

# `cannot set parameter "%s" to false for publication "%s"`

## What it means

A publication command tried to set a boolean publication parameter to false where only true is meaningful. The placeholders are the parameter name and the publication. Some publication options can be enabled but not explicitly disabled through that syntax.

## When it happens

`CREATE PUBLICATION` or `ALTER PUBLICATION ... SET (param = false)` for a parameter that does not accept false.

## How to fix

Omit the parameter instead of setting it to false, or consult the `CREATE PUBLICATION` documentation for which options are toggleable and how to turn them off. Setting the offending option to false is not a valid operation.

## Example

*Illustrative* — disabling a non-disableable publication option.

```text
ERROR:  cannot set parameter "publish_via_partition_root" to false for publication "p"
```

## Related

- [cannot alter conflict log table](./cannot-alter-conflict-log-table.md)
- [conflicting or redundant WHERE clauses for table](./conflicting-or-redundant-where-clauses-for-table.md)
