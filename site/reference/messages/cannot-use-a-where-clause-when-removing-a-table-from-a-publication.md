---
message: "cannot use a WHERE clause when removing a table from a publication"
slug: cannot-use-a-where-clause-when-removing-a-table-from-a-publication
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:2102"
reproduced: false
---

# `cannot use a WHERE clause when removing a table from a publication`

## What it means

An `ALTER PUBLICATION ... DROP TABLE` named a row filter with a `WHERE` clause. Removal takes the table out of the publication entirely, so a row filter has no role and is rejected.

## When it happens

It occurs when `ALTER PUBLICATION p DROP TABLE t WHERE (...)` includes a `WHERE` clause on the dropped table.

## How to fix

Drop the `WHERE` clause from the `DROP TABLE` action. To change a row filter, use `ALTER PUBLICATION ... SET TABLE t WHERE (...)` instead of dropping and re-adding.

## Example

*Illustrative* — a WHERE clause on DROP TABLE.

```sql
ALTER PUBLICATION p DROP TABLE t WHERE (a > 0);
-- ERROR:  cannot use a WHERE clause when removing a table from a publication
```

## Related

- [cannot use publication WHERE clause for relation](./cannot-use-publication-where-clause-for-relation.md)
- [cannot use system column in publication column list](./cannot-use-system-column-in-publication-column-list.md)
