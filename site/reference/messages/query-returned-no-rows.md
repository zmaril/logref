---
message: "query returned no rows"
slug: query-returned-no-rows
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NO_DATA_FOUND
    code: "P0002"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4485"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4675"
reproduced: false
---

# `query returned no rows`

## What it means

A statement that required exactly one result row got none. In PL/pgSQL this comes from a `SELECT ... INTO STRICT` (or an `INTO` with strict semantics) whose query matched nothing.

## When it happens

It arises in PL/pgSQL when a `STRICT` `INTO` query returns zero rows — the lookup found no matching record where the code assumed one would exist.

## How to fix

Decide how a missing row should be handled: catch `NO_DATA_FOUND` with an exception block, drop `STRICT` if zero rows is acceptable (leaving the target null), or fix the query/data so the expected row exists. Add a guard before assuming the lookup succeeds.

## Example

*Illustrative* — a STRICT INTO that matched no rows.

```text
ERROR:  query returned no rows
CONTEXT:  PL/pgSQL function get_user(integer) line 5 at SQL statement
```

## Related

- [query returned %d row instead of one: %s](./query-returned-row-instead-of-one.md)
- [source row not found](./source-row-not-found.md)
