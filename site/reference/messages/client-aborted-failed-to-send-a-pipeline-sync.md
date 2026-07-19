---
message: "client %d aborted: failed to send a pipeline sync"
slug: client-aborted-failed-to-send-a-pipeline-sync
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3535"
reproduced: false
---

# `client %d aborted: failed to send a pipeline sync`

## What it means

A `pgbench` client could not send a pipeline sync message to the server. Without the sync, the pipeline cannot be completed, so the client is aborted.

## When it happens

It occurs during a `pgbench` run inside a pipeline block when the connection fails while the client tries to send the sync that ends the pipeline.

## How to fix

This usually reflects a lost or broken connection. Check server availability and network health, review the server log, and rerun the benchmark once the connection is stable.

## Example

*Illustrative* — a failed pipeline sync.

```text
pgbench: error: client 0 aborted: failed to send a pipeline sync
```

## Related

- [client aborted end of script reached with pipeline open](./client-aborted-end-of-script-reached-with-pipeline-open.md)
- [client aborted while establishing connection](./client-aborted-while-establishing-connection.md)
