---
message: "could not connect to database \"%s\""
slug: could-not-connect-to-database-ec9b7c
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/connectdb.c:157"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:524"
reproduced: false
---

# `could not connect to database "%s"`

## What it means

The `pg_dump`/`pg_dumpall` tool could not open a connection to the named database. The placeholder is the database name. The initial connection attempt failed before any dumping could begin.

## When it happens

Running `pg_dump`/`pg_dumpall` with wrong connection parameters or credentials, against a server that is down or unreachable, or blocked by a `pg_hba.conf` rule.

## How to fix

Verify host, port, database name, user, and password, and that the server is up and reachable. Confirm `pg_hba.conf` permits the connection and authentication method. The accompanying detail line names the specific failure to resolve.

## Example

*Illustrative* — pg_dump failing to connect.

```text
pg_dump: error: could not connect to database "reporting"
```

## Related

- [connection to database failed](./connection-to-database-failed-b0df15.md)
- [could not fetch table info for table from publisher](./could-not-fetch-table-info-for-table-from-publisher.md)
