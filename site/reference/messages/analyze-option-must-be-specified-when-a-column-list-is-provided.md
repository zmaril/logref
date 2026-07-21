---
message: "ANALYZE option must be specified when a column list is provided"
slug: analyze-option-must-be-specified-when-a-column-list-is-provided
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:2400"
  - "postgres/src/backend/commands/vacuum.c:349"
reproduced: false
---

# `ANALYZE option must be specified when a column list is provided`

## What it means

A command was given a column list to analyze but not the `ANALYZE` option that a column list requires. Naming specific columns only makes sense when analyzing, so the option and the column list must appear together.

## When it happens

Running `VACUUM` or `REPACK` with a per-table column list but without the `ANALYZE` option, so the columns have no operation to apply to.

## How to fix

Add the `ANALYZE` option when you supply a column list, for example `VACUUM (ANALYZE) tbl (col1, col2)`. If you did not mean to analyze specific columns, remove the column list.

## Example

*Illustrative* — a column list without ANALYZE.

```sql
VACUUM t (a, b);  -- ANALYZE must be specified with a column list
```

## Related

- [cannot specify parameter](./cannot-specify-parameter.md)
- [invalid value for option](./invalid-value-for-option.md)
