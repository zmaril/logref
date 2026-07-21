---
message: "cursor \"%s\" is not positioned on a row"
slug: cursor-is-not-positioned-on-a-row
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:135"
  - "postgres/src/backend/executor/execCurrent.c:180"
reproduced: true
---

# `cursor "%s" is not positioned on a row`

## What it means

An `UPDATE ... WHERE CURRENT OF` or `DELETE ... WHERE CURRENT OF` referenced a cursor that is not currently positioned on a fetched row. The `%s` is the cursor name. There is no current row to update or delete.

## When it happens

Using `WHERE CURRENT OF` before the first `FETCH`, after the cursor moved past the last row, or when the last fetch returned no row.

## How to fix

`FETCH` a row into the cursor before issuing `WHERE CURRENT OF`, and ensure the fetch actually returned a row. Re-position the cursor onto a valid row first.

## Example

*Reproduced* — captured from `reproducers/scenarios/39_cte_cursors_prepared_lock.sql`.

```sql
UPDATE repro.parent SET label='x' WHERE CURRENT OF cp;
```

Produces:

```text
ERROR:  cursor "cp" is not positioned on a row
```

## Related

- [cursor can only scan forward](./cursor-can-only-scan-forward.md)
- [cursor variable is null](./cursor-variable-is-null.md)
