---
message: "configuration column \"%s\" does not exist"
slug: configuration-column-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/utils/adt/tsvector_op.c:2783"
reproduced: false
---

# `configuration column "%s" does not exist`

## What it means

A text-search configuration helper referenced a configuration column that does not exist in the target row type. The named column must be present so the operation can find the text-search configuration to use.

## When it happens

It happens with `tsvector`-maintenance helpers (such as `ts_stat` or trigger functions) when the configured column name is wrong or missing.

## How to fix

Use a column name that exists on the row, or correct the trigger/function arguments. Check spelling and confirm the column is defined.

## Example

*Illustrative* — a missing configuration column.

```text
ERROR:  configuration column "cfg" does not exist
```

## Related

- [configuration column must not be null](./configuration-column-must-not-be-null.md)
- [column is not of regconfig type](./column-is-not-of-regconfig-type.md)
