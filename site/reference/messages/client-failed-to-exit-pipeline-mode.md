---
message: "client %d failed to exit pipeline mode: %s"
slug: client-failed-to-exit-pipeline-mode
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3369"
reproduced: false
---

# `client %d failed to exit pipeline mode: %s`

## What it means

A `pgbench` client could not leave pipeline mode after finishing a pipeline block. The appended detail gives the driver-level reason. Because the connection state is inconsistent, the client cannot continue normally.

## When it happens

It occurs during a `pgbench` run at the end of a `\startpipeline`/`\endpipeline` block when the client library reports it cannot exit pipeline mode.

## How to fix

Read the appended reason, which comes from the client library. It usually reflects an outstanding error or a broken connection; fix the failing query or connection and rerun.

## Example

*Illustrative* — a failure exiting pipeline mode.

```text
pgbench: error: client 0 failed to exit pipeline mode: cannot exit pipeline mode with uncollected results
```

## Related

- [client aborted failed to exit pipeline mode for rolling back the failed](./client-aborted-failed-to-exit-pipeline-mode-for-rolling-back-the-failed.md)
- [client aborted end of script reached with pipeline open](./client-aborted-end-of-script-reached-with-pipeline-open.md)
