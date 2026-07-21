---
message: "column name \"%s\" specified more than once"
slug: column-name-specified-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/catalog/heap.c:496"
reproduced: false
---

# `column name "%s" specified more than once`

## What it means

A column-name list defined the same name twice. Table and result column names must be distinct within one definition, so a duplicate is rejected.

## When it happens

It happens in `CREATE TABLE`, a column definition list, or a similar construct when a column name is repeated.

## How to fix

Give each column a distinct name. Remove or rename the duplicate entry in the column list.

## Example

*Illustrative* — a duplicated column name.

```sql
CREATE TABLE t (a int, a text);
-- ERROR:  column name "a" specified more than once
```

## Related

- [column name is not unique](./column-name-is-not-unique.md)
- [column of relation already exists](./column-of-relation-already-exists.md)
