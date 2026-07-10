---
message: "relation \"%s\" does not exist"
slug: relation-does-not-exist-d06d8d
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_UNDEFINED_TABLE
    code: "42P01"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:637"
  - "postgres/src/backend/parser/parse_relation.c:1482"
  - "postgres/src/backend/parser/parse_relation.c:1490"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1695"
reproduced: false
---

# `relation "%s" does not exist`

**Severity:** ERROR (some call sites choose the severity at runtime) · SQLSTATE `42P01` (ERRCODE_UNDEFINED_TABLE)

## What it means

A query referred to a table, view, materialized view, sequence, or index that the server could not find. In Postgres all of these are "relations," which is why the wording is generic. The placeholder is the name as written in the statement.

## When it happens

Selecting from or modifying a name that does not resolve: a typo, a dropped object, a missing schema qualification, or an object that lives in a schema not on the `search_path`. Case matters — an identifier created with double quotes (`"MyTable"`) must be quoted the same way every time. It also appears when a connection points at the wrong database.

## How to fix

Confirm the object exists and how it is spelled: in `psql`, `\dt *.tablename` lists matching tables across schemas. Check your `search_path` (`SHOW search_path`) — if the table is in schema `app`, either qualify it as `app.tablename` or add the schema to the path. For quoted, mixed-case names, match the exact case and quoting. Verify you are connected to the intended database and role.

## Example

*Illustrative* — the catalog reproducer scenario selects from missing objects (`05_catalog.sql`).

```sql
SELECT * FROM nonexistent_table;
```

Produces:

```text
ERROR:  relation "nonexistent_table" does not exist
```

## Source

This message text is emitted from 4 call sites:

- [`postgres/src/backend/catalog/namespace.c:637`](https://github.com/postgres/postgres/blob/master/src/backend/catalog/namespace.c#L637) — severity chosen at runtime
- [`postgres/src/backend/parser/parse_relation.c:1482`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_relation.c#L1482) — ERROR
- [`postgres/src/backend/parser/parse_relation.c:1490`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_relation.c#L1490) — ERROR
- [`postgres/src/pl/plpgsql/src/pl_comp.c:1695`](https://github.com/postgres/postgres/blob/master/src/pl/plpgsql/src/pl_comp.c#L1695) — ERROR

## SQLSTATE

- `42P01` — **ERRCODE_UNDEFINED_TABLE**. Class 42 (Syntax Error or Access Rule Violation).

## Related

- [column "%s" does not exist](./column-does-not-exist-712d76.md)
- [relation "%s" already exists](./relation-already-exists.md)
- [permission denied for database](./permission-denied-for-database.md)
