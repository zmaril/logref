---
message: "cursor \"%s\" has multiple FOR UPDATE/SHARE references to table \"%s\""
slug: cursor-has-multiple-for-update-share-references-to-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:116"
reproduced: false
---

# `cursor "%s" has multiple FOR UPDATE/SHARE references to table "%s"`

## What it means

An `UPDATE` or `DELETE ... WHERE CURRENT OF` named a cursor that locks the target table in more than one place, so the positioned update cannot tell which row is current. The placeholders are the cursor and the table. The server reports it as an invalid cursor state.

## When it happens

It happens with `WHERE CURRENT OF` when the cursor's query joins the target table to itself, or otherwise references it more than once under `FOR UPDATE`/`FOR SHARE`, leaving the current row ambiguous.

## How to fix

Rewrite the cursor so the target table is locked in only one place, or restructure the update so it does not depend on `WHERE CURRENT OF` over an ambiguous join. A positioned update needs a single unambiguous current row in the table.

## Example

*Illustrative* — a self-join under FOR UPDATE.

```sql
DECLARE c CURSOR FOR SELECT * FROM t a JOIN t b USING (id) FOR UPDATE;
UPDATE t SET x = 1 WHERE CURRENT OF c;
-- ERROR:  cursor "c" has multiple FOR UPDATE/SHARE references to table "t"
```

## Related

- [cursor does not have a FOR UPDATE/SHARE reference to table](./cursor-does-not-have-a-for-update-share-reference-to-table.md)
- [cursor is not a SELECT query](./cursor-is-not-a-select-query.md)
