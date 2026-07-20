---
message: "improper qualified name (too many dotted names): %s"
slug: improper-qualified-name-too-many-dotted-names
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3405"
  - "postgres/src/backend/parser/parse_expr.c:888"
  - "postgres/src/backend/parser/parse_target.c:1272"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1369"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1402"
  - "postgres/src/bin/pg_dump/pg_dump.c:1670"
  - "postgres/src/bin/pg_dump/pg_dump.c:1726"
  - "postgres/src/bin/pg_dump/pg_dump.c:1779"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1582"
  - "postgres/src/bin/psql/describe.c:6447"
reproduced: false
---

# `improper qualified name (too many dotted names): %s`

## What it means

A qualified name had more dot-separated parts than allowed. The placeholder is the offending name. Postgres names go at most `database.schema.object` (and cross-database references are not allowed in queries), so a name with too many components is a syntax error.

## When it happens

Writing something like `a.b.c.d` as an object reference, over-qualifying a column (`db.schema.table.col.extra`), or a client that assembled a name with an extra component. It also appears when a name meant for another system's four-part naming is used in Postgres.

## How to fix

Reduce the name to at most the allowed parts. For a table use `schema.table`; for a column `table.column` or `schema.table.column`. Postgres does not support cross-database `database.schema.table` references in queries — connect to the target database instead (or use `dblink`/`postgres_fdw`).

## Example

*Illustrative* — an over-qualified name.

```sql
SELECT * FROM mydb.public.users.id;
```

Produces:

```text
ERROR:  improper qualified name (too many dotted names): mydb.public.users.id
```

## Related

- [column %s.%s does not exist](./column-does-not-exist-056a7f.md)
- [syntax error](./syntax-error.md)
