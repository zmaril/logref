---
message: "can only reindex the currently open database"
slug: can-only-reindex-the-currently-open-database
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:3314"
reproduced: true
---

# `can only reindex the currently open database`

## What it means

A `REINDEX DATABASE` or `REINDEX SYSTEM` command named a database other than the one the session is connected to. These commands act on the current database only, since reindexing requires access to that database's relations.

## When it happens

It occurs when running `REINDEX DATABASE other_db` or `REINDEX SYSTEM other_db` while connected to a different database.

## How to fix

Connect to the database you want to reindex and run `REINDEX DATABASE` naming that same database, or omit the name to target the current one. Use `reindexdb` with the right connection to reindex several databases.

## Example

*Reproduced* — captured from `reproducers/scenarios/34_guc_vacuum_copy_xml.sql`.

```sql
REINDEX DATABASE nonexistent_db;
```

Produces:

```text
ERROR:  can only reindex the currently open database
```

## Related

- [cannot access index while it is being reindexed](./cannot-access-index-while-it-is-being-reindexed.md)
- [can only export one snapshot at a time](./can-only-export-one-snapshot-at-a-time.md)
