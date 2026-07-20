---
message: "unexpected result from fetch_attstats query"
slug: unexpected-result-from-fetch-attstats-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:5921"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:6128"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:6138"
reproduced: false
---

# `unexpected result from fetch_attstats query`

## What it means

Internal error in postgres_fdw. When gathering statistics from a remote server, the wrapper ran a query to fetch column statistics and received a result whose shape did not match what it expected. It is a consistency check on the remote statistics fetch.

## When it happens

It should not occur when both ends run compatible versions. Reaching it points to a version mismatch between the local wrapper and the remote server, or an internal inconsistency, rather than to your foreign-table definition as such.

## How to fix

Treat it as a compatibility or internal-bug signal. Confirm the local and remote servers are compatible versions, since the statistics query's expected shape can differ across versions. Capture the operation (typically an `ANALYZE` on a foreign table) and report it if versions match.

## Example

*Illustrative* — an unexpected remote statistics result.

```text
ERROR:  unexpected result from fetch_attstats query
```

## Related

- [discarding connection](./discarding-connection.md)
- [unexpected termination of replication stream](./unexpected-termination-of-replication-stream.md)
