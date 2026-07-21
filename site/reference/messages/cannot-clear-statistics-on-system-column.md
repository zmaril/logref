---
message: "cannot clear statistics on system column \"%s\""
slug: cannot-clear-statistics-on-system-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/statistics/attribute_stats.c:631"
reproduced: false
---

# `cannot clear statistics on system column "%s"`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... SET STATISTICS` (or the equivalent that resets statistics) named a system column such as `ctid` or `xmin`. Statistics targets apply only to user columns, so clearing them on a system column is rejected. The placeholder is the column name.

## When it happens

It occurs when a statistics-related `ALTER COLUMN` names one of a table's hidden system columns.

## How to fix

Apply statistics settings only to ordinary user columns. System columns do not carry planner statistics, so there is nothing to set or clear on them.

## Example

*Illustrative* — statistics on a system column.

```text
ERROR:  cannot clear statistics on system column "ctid"
```

## Related

- [cannot change data type of view column from to](./cannot-change-data-type-of-view-column-from-to.md)
- [cannot check relation](./cannot-check-relation.md)
