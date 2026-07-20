---
message: "cannot alter type of column \"%s\" twice"
slug: cannot-alter-type-of-column-twice
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15317"
reproduced: false
---

# `cannot alter type of column "%s" twice`

## What it means

A single `ALTER TABLE` statement tried to change the same column's type more than once. Postgres processes one type change per column in a command, and a second `ALTER COLUMN ... TYPE` on the same column is rejected.

## When it happens

It occurs when one `ALTER TABLE` lists two `ALTER COLUMN ... TYPE` actions naming the same column.

## How to fix

Keep a single type change per column in each statement. If you need to reach a final type, alter it once to that type, or split the changes across separate `ALTER TABLE` statements.

## Example

*Illustrative* — two type changes on one column.

```sql
ALTER TABLE t ALTER c TYPE int, ALTER c TYPE bigint;
```

## Related

- [cannot alter type of a column used by a view or rule](./cannot-alter-type-of-a-column-used-by-a-view-or-rule.md)
- [cannot change data type of view column from to](./cannot-change-data-type-of-view-column-from-to.md)
