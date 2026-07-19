---
message: "client %d aborted: failed to exit pipeline mode for rolling back the failed transaction"
slug: client-aborted-failed-to-exit-pipeline-mode-for-rolling-back-the-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3582"
reproduced: false
---

# `client %d aborted: failed to exit pipeline mode for rolling back the failed transaction`

## What it means

A `pgbench` client hit an error inside a pipeline and could not leave pipeline mode to roll back the failed transaction. Because it could not recover the connection state, the client is aborted.

## When it happens

It occurs during a `pgbench` run when an error inside a `\startpipeline` block prevents the client from exiting pipeline mode cleanly.

## How to fix

Look for the earlier error that put the pipeline into a failed state, since this message follows it. Fix the failing query or the pipeline structure in the script, then rerun.

## Example

*Illustrative* — pipeline recovery failing after an error.

```text
pgbench: error: client 0 aborted: failed to exit pipeline mode for rolling back the failed transaction
```

## Related

- [client aborted failed to send sql command for rolling back the failed](./client-aborted-failed-to-send-sql-command-for-rolling-back-the-failed.md)
- [client aborted failed to send a pipeline sync](./client-aborted-failed-to-send-a-pipeline-sync.md)
