---
message: "could not connect to databases \"postgres\" or \"template1\"\nPlease specify an alternative database."
slug: could-not-connect-to-databases-postgres-or-template1-please-specify-an
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dumpall.c:538"
reproduced: false
---

# `could not connect to databases "postgres" or "template1"
Please specify an alternative database.`

## What it means

`pg_dumpall` could not open a maintenance connection to either the `postgres` or the `template1` database. It needs one of these as an entry point to read the cluster's global objects, and both were unreachable.

## When it happens

It happens at the start of a `pg_dumpall` run when neither default database can be connected to — for example both were dropped or renamed, or connection options point at the wrong cluster.

## How to fix

Pass an existing maintenance database with `-l`/`--database`, or restore one of `postgres`/`template1`. Confirm the connection options reach the intended cluster and the role has permission to connect.

## Example

*Illustrative* — `pg_dumpall` with no reachable maintenance database.

```text
pg_dumpall: error: could not connect to databases "postgres" or "template1"
Please specify an alternative database.
```

## Related

- [could not connect to database: out of memory](./could-not-connect-to-database-out-of-memory.md)
- [could not determine the number of users](./could-not-determine-the-number-of-users.md)
