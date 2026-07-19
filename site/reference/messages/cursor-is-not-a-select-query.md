---
message: "cursor \"%s\" is not a SELECT query"
slug: cursor-is-not-a-select-query
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:77"
reproduced: false
---

# `cursor "%s" is not a SELECT query`

## What it means

An operation that needs a read-only cursor over a `SELECT` was given a cursor whose query is something else. The placeholder is the cursor name. Positioned updates and some cursor operations require the cursor to be a plain query. The server reports it as an invalid cursor state.

## When it happens

It happens when `WHERE CURRENT OF` or a similar operation targets a cursor that was declared over a non-`SELECT` statement, so there is no current row from a query to reference.

## How to fix

Declare the cursor over a `SELECT` (with `FOR UPDATE` if you intend positioned updates). The cursor must scan rows from a query for `WHERE CURRENT OF` to have a current row to act on.

## Example

*Illustrative* — a cursor not over a SELECT.

```text
ERROR:  cursor "c" is not a SELECT query
```

## Related

- [cursor already exists](./cursor-already-exists.md)
- [cursor does not have a FOR UPDATE/SHARE reference to table](./cursor-does-not-have-a-for-update-share-reference-to-table.md)
