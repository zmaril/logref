---
message: "conflicting or redundant options"
slug: conflicting-or-redundant-options
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/contrib/file_fdw/file_fdw.c:264"
  - "postgres/contrib/file_fdw/file_fdw.c:315"
  - "postgres/contrib/file_fdw/file_fdw.c:327"
  - "postgres/src/backend/commands/collationcmds.c:126"
  - "postgres/src/backend/commands/collationcmds.c:132"
  - "postgres/src/backend/commands/define.c:372"
  - "postgres/src/backend/commands/tablecmds.c:8543"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:321"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:344"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:362"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:372"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:382"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:392"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:404"
  - "postgres/src/backend/replication/walsender.c:1199"
  - "postgres/src/backend/replication/walsender.c:1221"
  - "postgres/src/backend/replication/walsender.c:1231"
  - "postgres/src/backend/replication/walsender.c:1240"
  - "postgres/src/backend/replication/walsender.c:1491"
  - "postgres/src/backend/replication/walsender.c:1500"
reproduced: false
---

# `conflicting or redundant options`

## What it means

A command was given two options that contradict each other, or the same option twice. Postgres parses options into a set and rejects duplicates or mutually exclusive combinations rather than silently picking one.

## When it happens

DDL and utility statements with option lists — `CREATE`/`ALTER` for functions, collations, extensions, subscriptions, `COPY`, and foreign-data objects. For example specifying `IMMUTABLE` and `VOLATILE` together, or repeating an option in a `WITH (...)` clause.

## How to fix

Remove the duplicate, or keep only one of the conflicting options. The error usually follows the offending clause; review the option list and delete the contradiction. Consult the statement's documentation for which options are mutually exclusive.

## Example

*Illustrative* — contradictory volatility markers on a function.

```sql
CREATE FUNCTION f() RETURNS int IMMUTABLE VOLATILE AS 'SELECT 1' LANGUAGE sql;
```

Produces:

```text
ERROR:  conflicting or redundant options
```

## Related

- [option not recognized](./option-not-recognized.md)
- [options %s and %s cannot be used together](./options-and-cannot-be-used-together-8b5f2b.md)
