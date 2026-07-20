---
message: "column \"%s\" appears twice in unique constraint"
slug: column-appears-twice-in-unique-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:2757"
reproduced: false
---

# `column "%s" appears twice in unique constraint`

## What it means

A `UNIQUE` constraint definition listed the same column more than once. A unique constraint's columns must be distinct, so a repeated column is rejected.

## When it happens

It occurs on `CREATE TABLE` or `ALTER TABLE ... ADD UNIQUE` when a column name appears twice in the constraint column list.

## How to fix

List each column once. Remove the duplicate from the unique constraint definition.

## Example

*Illustrative* — a repeated unique-constraint column.

```sql
ALTER TABLE t ADD UNIQUE (a, a);
-- ERROR:  column "a" appears twice in unique constraint
```

## Related

- [column appears twice in primary key constraint](./column-appears-twice-in-primary-key-constraint.md)
- [check constraint already exists](./check-constraint-already-exists.md)
