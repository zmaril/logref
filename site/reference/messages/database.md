---
message: "database \"%s\": %s"
slug: database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:577"
reproduced: false
---

# `database "%s": %s`

## What it means

`pg_amcheck` is relaying an error tied to a specific database. The first placeholder is the database name and the second is the underlying message. This is a wrapper the tool uses to attach the database context to a problem it hit.

## When it happens

It fires while `pg_amcheck` connects to or processes a named database and something goes wrong — a connection problem, a permission issue, or an error running its checks there.

## How to fix

Read the trailing message, which carries the real cause. Address that — for example a connection or privilege problem for the named database — and rerun `pg_amcheck`. The database name simply tells you which target the underlying error applies to.

## Example

*Illustrative* — a per-database error from pg_amcheck.

```text
pg_amcheck: error: database "sales": connection failed
```

## Related

- [database creation failed](./database-creation-failed.md)
- [database removal failed](./database-removal-failed.md)
