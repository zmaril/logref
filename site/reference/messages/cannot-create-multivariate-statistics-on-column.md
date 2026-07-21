---
message: "cannot create multivariate statistics on column \"%s\""
slug: cannot-create-multivariate-statistics-on-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:295"
  - "postgres/src/backend/commands/statscmds.c:342"
reproduced: false
---

# `cannot create multivariate statistics on column "%s"`

## What it means

A `CREATE STATISTICS` command referenced a column that cannot participate in extended (multivariate) statistics. The placeholder is the column name. The column's type or nature — for example a system column or an unsupported type — makes it ineligible.

## When it happens

Running `CREATE STATISTICS` over a column list that includes a system column, an expression that is not allowed, or a column whose type has no suitable statistics support.

## How to fix

Build the statistics object over ordinary user columns of supported types. Remove the offending column from the column list, or use an expression form the statistics feature accepts. Check the column's type and whether it is a system column.

## Example

*Illustrative* — statistics on an unsupported column.

```text
ERROR:  cannot create multivariate statistics on column "ctid"
```

## Related

- [cannot create primary key on column](./cannot-create-primary-key-on-column.md)
- [column name conflicts with a system column name](./column-name-conflicts-with-a-system-column-name.md)
