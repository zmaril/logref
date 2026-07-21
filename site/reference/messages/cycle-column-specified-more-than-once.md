---
message: "cycle column \"%s\" specified more than once"
slug: cycle-column-specified-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/parser/parse_cte.c:510"
reproduced: true
---

# `cycle column "%s" specified more than once`

## What it means

A recursive `WITH ... CYCLE` clause listed the same cycle-detection column twice. The placeholder is the column. Each column in the `CYCLE` list must be distinct. The server reports it as a duplicate column.

## When it happens

It happens when the column list after `CYCLE` repeats a column name.

## How to fix

Remove the duplicate so each column appears once in the `CYCLE` list. The list should name the set of columns that together identify a repeated row.

## Example

*Reproduced* — captured from `reproducers/scenarios/39_cte_cursors_prepared_lock.sql`.

```sql
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) CYCLE n, n SET c USING p SELECT * FROM t;
```

Produces:

```text
ERROR:  cycle column "n" specified more than once
```

## Related

- [cycle column not in WITH query column list](./cycle-column-not-in-with-query-column-list.md)
- [cycle mark column name and cycle path column name are the same](./cycle-mark-column-name-and-cycle-path-column-name-are-the-same.md)
