---
message: "cached plan must not change result type"
slug: cached-plan-must-not-change-result-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/functions.c:1269"
  - "postgres/src/backend/utils/cache/plancache.c:875"
reproduced: false
---

# `cached plan must not change result type`

## What it means

A prepared statement or cached plan was re-executed, but the result column set it would now produce differs from the one it produced when first planned. Postgres refuses to silently return a different row shape to a client that prepared against the old one.

## When it happens

The definition of a table or view referenced by a prepared statement, a PL/pgSQL cached query, or a SQL-function body changed underneath it — for example an `ALTER TABLE ... ADD/DROP COLUMN` or a view redefinition between preparing and executing.

## How to fix

Re-prepare the statement (or reconnect, or start a fresh session) so the plan is rebuilt against the current schema. In PL/pgSQL, the function's cached plans reset on a new session; deploying schema changes and then reconnecting clears it. Avoid changing the result columns of objects that live prepared statements depend on while those statements are in use.

## Example

*Illustrative* — a column added to a table a prepared statement selects from.

```sql
PREPARE s AS SELECT * FROM t;
ALTER TABLE t ADD COLUMN c int;
EXECUTE s;  -- ERROR: cached plan must not change result type
```

## Related

- [cannot alter type because column uses it](./cannot-alter-type-because-column-uses-it.md)
- [could not convert row type](./could-not-convert-row-type.md)
