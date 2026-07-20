---
message: "column \"%s\" appears twice in primary key constraint"
slug: column-appears-twice-in-primary-key-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:2751"
reproduced: false
---

# `column "%s" appears twice in primary key constraint`

## What it means

A `PRIMARY KEY` definition listed the same column more than once. A primary key's columns must be distinct, so a repeated column is rejected.

## When it happens

It occurs on `CREATE TABLE` or `ALTER TABLE ... ADD PRIMARY KEY` when a column name appears twice in the key column list.

## How to fix

List each key column once. Remove the duplicate from the primary key definition.

## Example

*Illustrative* — a repeated primary-key column.

```sql
ALTER TABLE t ADD PRIMARY KEY (a, a);
-- ERROR:  column "a" appears twice in primary key constraint
```

## Related

- [column appears twice in unique constraint](./column-appears-twice-in-unique-constraint.md)
- [check constraint already exists](./check-constraint-already-exists.md)
