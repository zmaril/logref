---
message: "cannot copy window \"%s\" because it has a frame clause"
slug: cannot-copy-window-because-it-has-a-frame-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WINDOWING_ERROR
    code: "42P20"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:3102"
  - "postgres/src/backend/parser/parse_clause.c:3108"
reproduced: false
---

# `cannot copy window "%s" because it has a frame clause`

## What it means

A window definition tried to reuse (copy) an existing named window that carries a frame clause. The placeholder is the window name. SQL forbids inheriting from a window that has its own `ROWS`/`RANGE`/`GROUPS` frame, because the frame cannot be meaningfully extended.

## When it happens

Writing `WINDOW w2 AS (w1 ...)` where `w1` already specifies a frame clause, in a query with a `WINDOW` clause that layers window definitions.

## How to fix

Define the second window from scratch with its own partition, order, and frame, rather than copying a window that already has a frame. Only windows without a frame clause can be used as a base for another window.

## Example

*Illustrative* — copying a framed window.

```sql
SELECT sum(x) OVER w2 FROM t
  WINDOW w1 AS (ORDER BY x ROWS 1 PRECEDING), w2 AS (w1);
-- ERROR:  cannot copy window "w1" because it has a frame clause
```

## Related

- [cannot be specified multiple times](./cannot-be-specified-multiple-times.md)
- [cannot be applied to VALUES](./cannot-be-applied-to-values.md)
