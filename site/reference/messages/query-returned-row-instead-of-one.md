---
message: "query returned %d row instead of one: %s"
slug: query-returned-row-instead-of-one
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_db.c:258"
  - "postgres/src/bin/scripts/common.c:106"
reproduced: false
---

# `query returned %d row instead of one: %s`

## What it means

A statement that required exactly one result row got a different number. The placeholders are the actual row count and query text. In PL/pgSQL this comes from a `SELECT ... INTO STRICT` that matched more than one row (or, phrased this way, the wrong count).

## When it happens

It arises in PL/pgSQL when a `STRICT` `INTO` query returns more than one row — the query is less selective than the code assumed.

## How to fix

Make the query select exactly one row (add a more specific `WHERE`, a unique key, or `LIMIT 1` with a deliberate `ORDER BY`), or loop over the results instead of using `STRICT`. If duplicates are unexpected, investigate the data.

## Example

*Illustrative* — a STRICT INTO matching multiple rows.

```text
ERROR:  query returned 3 rows instead of one: SELECT id INTO STRICT ...
```

## Related

- [query returned no rows](./query-returned-no-rows.md)
- [subquery must return only one column](./subquery-must-return-only-one-column.md)
