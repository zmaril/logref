---
message: "query returned more than one row"
slug: query-returned-more-than-one-row
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_CARDINALITY_VIOLATION
    code: "21000"
  - symbol: ERRCODE_TOO_MANY_ROWS
    code: "P0003"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4507"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4694"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5832"
reproduced: false
---

# `query returned more than one row`

## What it means

A PL/pgSQL statement that expects at most one row — such as `SELECT ... INTO` or a query behind `STRICT` handling — received more than one. The single-row context cannot hold multiple rows, so it is an error rather than an arbitrary pick.

## When it happens

Running `SELECT ... INTO var` (or `EXECUTE ... INTO`, or a `PERFORM`/`GET` context declared `STRICT`) where the query matches several rows because its filter is not selective enough or a join key is not unique.

## How to fix

Make the query return one row: tighten its `WHERE`, add the missing key, or aggregate to collapse duplicates. If any single match is acceptable, add `ORDER BY ... LIMIT 1` to choose deterministically. If several rows are expected, loop over them with `FOR ... IN` instead of assigning into a scalar.

## Example

*Illustrative* — INTO a scalar with multiple matches.

```sql
SELECT id INTO v FROM users WHERE active;  -- more than one active user
```

## Related

- [query returned no rows](./query-returned-no-rows.md)
- [more than one row returned by a subquery used as an expression](./more-than-one-row-returned-by-a-subquery-used-as-an-expression.md)
