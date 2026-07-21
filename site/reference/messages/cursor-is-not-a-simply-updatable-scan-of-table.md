---
message: "cursor \"%s\" is not a simply updatable scan of table \"%s\""
slug: cursor-is-not-a-simply-updatable-scan-of-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:167"
  - "postgres/src/backend/executor/execCurrent.c:226"
  - "postgres/src/backend/executor/execCurrent.c:237"
reproduced: false
---

# `cursor "%s" is not a simply updatable scan of table "%s"`

## What it means

A `WHERE CURRENT OF cursor` update or delete referenced a cursor whose query is not a simple, directly-updatable scan of the target table. The placeholders name the cursor and table. `WHERE CURRENT OF` requires the cursor to be a straightforward scan (no joins, grouping, `DISTINCT`, etc.) so the current row maps unambiguously to one table row.

## When it happens

Using `UPDATE ... WHERE CURRENT OF c` / `DELETE ... WHERE CURRENT OF c` where cursor `c` was declared over a query with joins, aggregation, `DISTINCT`, `ORDER BY` with certain forms, or otherwise not a plain updatable scan of the table.

## How to fix

Declare the cursor as a simple `SELECT` over the single target table (optionally `FOR UPDATE`) so `WHERE CURRENT OF` can identify the row. If you need a complex query, fetch a stable row identifier (a primary key) and update by that key instead of `WHERE CURRENT OF`.

## Example

*Illustrative* — CURRENT OF on a non-updatable cursor.

```sql
DECLARE c CURSOR FOR SELECT * FROM a JOIN b USING (id);
UPDATE a SET x=1 WHERE CURRENT OF c;  -- not a simply updatable scan
```

## Related

- [cannot update table](./cannot-update-table.md)
- [command cannot affect row a second time](./command-cannot-affect-row-a-second-time.md)
