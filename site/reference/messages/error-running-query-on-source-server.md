---
message: "error running query (%s) on source server: %s"
slug: error-running-query-on-source-server
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/libpq_source.c:171"
reproduced: false
---

# `error running query (%s) on source server: %s`

## What it means

`pg_rewind` ran a query on the source server and it failed. The placeholders are the query and the error. This variant covers a different set of `pg_rewind` source-server queries but means the same thing: the source rejected the query.

## When it happens

It fires in `pg_rewind` (in libpq source mode) when a query against the source server errors — permissions, a missing feature, or a connection fault.

## How to fix

Read the reported error and check the source server's log. Verify the connection string and the connecting role's privileges, and that the source is an available primary. Resolve the cause and rerun `pg_rewind`.

## Example

*Illustrative* — a source-server query failure.

```text
pg_rewind: fatal: error running query (SELECT ...) on source server: ...
```

## Related

- [error running query in source server](./error-running-query-in-source-server.md)
- [error sending command to database](./error-sending-command-to-database.md)
