---
message: "statistics creation on system columns is not supported"
slug: statistics-creation-on-system-columns-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:283"
  - "postgres/src/backend/commands/statscmds.c:330"
  - "postgres/src/backend/commands/statscmds.c:380"
reproduced: false
---

# `statistics creation on system columns is not supported`

## What it means

An extended-statistics object was defined over a system column. Extended statistics can be built only on ordinary user columns, not on the hidden system columns such as the row identifier, so the request was rejected.

## When it happens

Running `CREATE STATISTICS` with a system column (for example `ctid` or `xmin`) among its columns, usually by naming a system column by mistake.

## How to fix

List only regular user columns in the statistics object. Remove any system column from the column list; extended statistics describe relationships among user data columns and do not apply to system columns.

## Example

*Illustrative* — statistics over a system column.

```sql
CREATE STATISTICS s ON ctid, id FROM t;  -- ctid is a system column
```

## Related

- [cannot specify parameter](./cannot-specify-parameter.md)
- [duplicate column name in statistics definition](./duplicate-column-name-in-statistics-definition.md)
