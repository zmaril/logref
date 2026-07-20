---
message: "unexpected PQresultStatus: %d"
slug: unexpected-pqresultstatus
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/common.c:447"
  - "postgres/src/bin/psql/common.c:1099"
reproduced: false
---

# `unexpected PQresultStatus: %d`

## What it means

Internal error. Code driving a libpq connection (for example a parallel worker, `postgres_fdw`, or a background tool) received a result status from a query that it has no case for.

## When it happens

It fires when a libpq round-trip returns a status outside the set the caller handles. It usually shadows an earlier, more informative failure on the same connection.

## How to fix

This is an internal guard. Look for a preceding error on the same connection — a lost server, a cancelled query, or a protocol desync — which is the real cause; report the pairing if it recurs.

## Example

*Illustrative* — an unhandled libpq result status.

```text
ERROR:  unexpected PQresultStatus: 8
```

## Related

- [unexpected result after CommandComplete: %s](./unexpected-result-after-commandcomplete.md)
- [unexpected error status: %d](./unexpected-error-status.md)
