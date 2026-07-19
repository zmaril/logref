---
message: "cannot access temporary tables of other sessions"
slug: cannot-access-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/amcheck/verify_common.c:177"
  - "postgres/contrib/pageinspect/btreefuncs.c:240"
  - "postgres/contrib/pageinspect/btreefuncs.c:873"
  - "postgres/contrib/pageinspect/hashfuncs.c:431"
  - "postgres/contrib/pageinspect/rawpage.c:174"
  - "postgres/contrib/pgstattuple/pgstatapprox.c:331"
  - "postgres/contrib/pgstattuple/pgstatindex.c:237"
  - "postgres/contrib/pgstattuple/pgstattuple.c:253"
  - "postgres/src/backend/storage/aio/read_stream.c:785"
reproduced: false
---

# `cannot access temporary tables of other sessions`

## What it means

An operation tried to read a temporary table that belongs to a different session. Temporary tables are private to the session that created them — their data lives in that session's temp buffers — so another session (or a background process) cannot access their contents.

## When it happens

Inspection functions (`pgstattuple`, `pageinspect`, `pg_visibility`), autovacuum, or cross-session tooling touching a temp table owned by someone else, or a query that reached another session's temp schema. The catalog entry is visible, but the data is not accessible.

## How to fix

Do not attempt to read another session's temp table — it is impossible by design. If you need shared, inspectable data, use a regular (non-temporary) table. For inspection functions, run them in the session that owns the temp table. There is no way to grant cross-session access to temp table contents.

## Example

*Illustrative* — inspecting another session's temp table.

```sql
SELECT * FROM pgstattuple('pg_temp_3.mytemp');
```

Produces:

```text
ERROR:  cannot access temporary tables of other sessions
```

## Related

- [must be superuser to use pgstattuple functions](./must-be-superuser-to-use-pgstattuple-functions.md)
- [only heap AM is supported](./only-heap-am-is-supported.md)
