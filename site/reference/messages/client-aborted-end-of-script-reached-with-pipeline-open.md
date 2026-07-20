---
message: "client %d aborted: end of script reached with pipeline open"
slug: client-aborted-end-of-script-reached-with-pipeline-open
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3862"
reproduced: false
---

# `client %d aborted: end of script reached with pipeline open`

## What it means

A `pgbench` client reached the end of its script while a pipeline was still open. Scripts that start a pipeline must close it before finishing, so the client is aborted.

## When it happens

It occurs during a `pgbench` run when a custom script uses `\startpipeline` without a matching `\endpipeline` before the script ends.

## How to fix

Add `\endpipeline` to close the pipeline before the script finishes. Balance every `\startpipeline` with an `\endpipeline` in the benchmark script.

## Example

*Illustrative* — a script ending with an open pipeline.

```text
pgbench: error: client 0 aborted: end of script reached with pipeline open
```

## Related

- [client aborted end of script reached without completing the last transaction](./client-aborted-end-of-script-reached-without-completing-the-last-transaction.md)
- [client aborted failed to send a pipeline sync](./client-aborted-failed-to-send-a-pipeline-sync.md)
