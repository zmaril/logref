---
message: "column name \"%s\" conflicts with a system column name"
slug: column-name-conflicts-with-a-system-column-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/catalog/heap.c:480"
  - "postgres/src/backend/commands/tablecmds.c:7812"
reproduced: false
---

# `column name "%s" conflicts with a system column name`

## What it means

A `CREATE`/`ALTER TABLE` tried to define a user column whose name matches a system column (`ctid`, `xmin`, `xmax`, `cmin`, `cmax`, `tableoid`). The placeholder is the column name. Those names are reserved for the system columns every table has.

## When it happens

Adding or renaming a column to one of the reserved system-column names, often from a schema imported from another database that does not reserve those identifiers.

## How to fix

Choose a different column name that does not collide with a system column. If migrating from another system, rename the offending column (for example add a prefix or suffix) so it no longer matches a reserved name.

## Example

*Illustrative* — a user column named after a system column.

```sql
ALTER TABLE t ADD COLUMN xmin int;
-- ERROR:  column name "xmin" conflicts with a system column name
```

## Related

- [cannot add not-null constraint on system column](./cannot-add-not-null-constraint-on-system-column.md)
- [cannot create multivariate statistics on column](./cannot-create-multivariate-statistics-on-column.md)
