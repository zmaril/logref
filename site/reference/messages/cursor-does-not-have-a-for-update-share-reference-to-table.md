---
message: "cursor \"%s\" does not have a FOR UPDATE/SHARE reference to table \"%s\""
slug: cursor-does-not-have-a-for-update-share-reference-to-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:125"
reproduced: false
---

# `cursor "%s" does not have a FOR UPDATE/SHARE reference to table "%s"`

## What it means

An `UPDATE` or `DELETE ... WHERE CURRENT OF` named a cursor that has no `FOR UPDATE` or `FOR SHARE` lock on the target table. The placeholders are the cursor and the table. Positioned updates require the cursor to hold a row lock on that table. The server reports it as an invalid cursor state.

## When it happens

It happens with `WHERE CURRENT OF cursor` when the cursor's query did not include `FOR UPDATE`/`FOR SHARE` referencing the table you are updating.

## How to fix

Declare the cursor with `FOR UPDATE` (or `FOR SHARE`) on the table you intend to modify, so it holds the row lock a positioned update needs. Then `WHERE CURRENT OF` can locate and update the current row.

## Example

*Illustrative* — a cursor without FOR UPDATE.

```sql
DECLARE c CURSOR FOR SELECT * FROM t;
UPDATE t SET x = 1 WHERE CURRENT OF c;
-- ERROR:  cursor "c" does not have a FOR UPDATE/SHARE reference to table "t"
```

## Related

- [cursor has multiple FOR UPDATE/SHARE references to table](./cursor-has-multiple-for-update-share-references-to-table.md)
- [cursor is not a SELECT query](./cursor-is-not-a-select-query.md)
