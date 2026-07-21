---
message: "error running query (%s) in source server: %s"
slug: error-running-query-in-source-server
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/libpq_source.c:198"
reproduced: false
---

# `error running query (%s) in source server: %s`

## What it means

`pg_rewind` ran a query on the source server and it failed. The placeholders are the query and the error. `pg_rewind` queries the source (the server it rewinds toward) over libpq and got an error back.

## When it happens

It fires in `pg_rewind` (in libpq source mode) when a query against the source server errors — a permissions problem, a missing function, or a connection fault.

## How to fix

Check the reported error and the source server's log. Confirm the connection string, that the connecting role has the required privileges (a superuser or a suitably granted role), and that the source is a running primary. Fix the underlying cause and rerun.

## Example

*Illustrative* — a source-server query failure.

```text
pg_rewind: fatal: error running query (SELECT ...) in source server: ...
```

## Related

- [error running query on source server](./error-running-query-on-source-server.md)
- [error sending command to database](./error-sending-command-to-database.md)
