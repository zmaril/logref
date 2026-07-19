---
message: "multiple primary keys for table \"%s\" are not allowed"
slug: multiple-primary-keys-for-table-are-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/catalog/index.c:219"
  - "postgres/src/backend/parser/parse_utilcmd.c:2356"
reproduced: false
---

# `multiple primary keys for table "%s" are not allowed`

## What it means

A table definition tried to declare more than one primary key. A table may have at most one primary key. The placeholder is the table name.

## When it happens

It arises in `CREATE TABLE` with two `PRIMARY KEY` declarations, or `ALTER TABLE ... ADD PRIMARY KEY` on a table that already has one.

## How to fix

Declare a single primary key. To key on several columns, use one composite `PRIMARY KEY (a, b)`. For additional uniqueness guarantees, add `UNIQUE` constraints rather than a second primary key.

## Example

*Illustrative* — two primary keys in one table.

```sql
CREATE TABLE t (a int PRIMARY KEY, b int PRIMARY KEY);  -- only one allowed
```

## Related

- [multiple assignments to same column](./multiple-assignments-to-same-column.md)
- [number of columns exceeds limit](./number-of-columns-exceeds-limit.md)
