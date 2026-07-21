---
message: "discarding connection %p"
slug: discarding-connection
passthrough: false
api: [elog]
level: [DEBUG3]
call_sites:
  - "postgres/contrib/postgres_fdw/connection.c:1473"
  - "postgres/contrib/postgres_fdw/connection.c:1541"
  - "postgres/contrib/postgres_fdw/connection.c:2641"
reproduced: false
---

# `discarding connection %p`

## What it means

A debug trace line from postgres_fdw, reporting that it is discarding a cached connection to a remote server. Raised at a deep debug level, it records connection-pool housekeeping, not a fault.

## When it happens

During postgres_fdw operation with deep debug tracing enabled, when the wrapper drops a pooled remote connection — for example because it is no longer valid or is being cleaned up at transaction end.

## Is this a problem?

No action is needed. It is internal connection-management tracing. If it appears at an ordinary log level, review the log verbosity for the foreign-data-wrapper, since it is meant for debugging.

## Example

*Illustrative* — a foreign connection being discarded.

```text
DEBUG:  discarding connection 0x5567abcd
```

## Related

- [client sending](./client-sending.md)
- [unexpected result from fetch attstats query](./unexpected-result-from-fetch-attstats-query.md)
