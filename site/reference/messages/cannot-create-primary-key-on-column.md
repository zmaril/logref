---
message: "cannot create primary key on column \"%s\""
slug: cannot-create-primary-key-on-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9722"
  - "postgres/src/backend/commands/tablecmds.c:9734"
reproduced: false
---

# `cannot create primary key on column "%s"`

## What it means

A primary-key definition named a column that cannot serve as (part of) a primary key. The placeholder is the column name. The column is in a state — for example a system column, or a column whose not-null or type prerequisites are not met — that disqualifies it.

## When it happens

Adding a primary key over a column that is a system column, or over a set of columns where one cannot be made NOT NULL as a primary key requires.

## How to fix

Choose eligible user columns for the primary key, ensure each can be NOT NULL, and confirm the column type supports the required unique index. Correct the column list in the `PRIMARY KEY` clause.

## Example

*Illustrative* — a primary key on an ineligible column.

```text
ERROR:  cannot create primary key on column "ctid"
```

## Related

- [cannot create multivariate statistics on column](./cannot-create-multivariate-statistics-on-column.md)
- [column in child table must be marked NOT NULL](./column-in-child-table-must-be-marked-not-null.md)
