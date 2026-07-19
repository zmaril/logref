---
message: "\\%s not allowed in pipeline mode"
slug: not-allowed-in-pipeline-mode
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:1767"
  - "postgres/src/bin/psql/command.c:1974"
  - "postgres/src/bin/psql/command.c:2000"
  - "postgres/src/bin/psql/command.c:3382"
reproduced: false
---

# `\%s not allowed in pipeline mode`

## What it means

A `psql` backslash command was issued while the session was in pipeline mode, where it is not allowed. The placeholder names the command. Pipeline mode batches queries without waiting for each result, and some meta-commands assume synchronous round-trips that pipelining breaks, so they are refused inside a pipeline.

## When it happens

Using a meta-command such as `\g` variants, a sync-requiring command, or another disallowed backslash command between `\startpipeline` and `\endpipeline` in `psql`.

## How to fix

Move the command outside the pipeline: close the pipeline with `\endpipeline` (or don't start one) before running it, or restructure the batch so only pipeline-safe commands appear between `\startpipeline` and `\endpipeline`. Use `\bind` / `\sendpipeline` for the queries you want to pipeline.

## Example

*Illustrative* — a disallowed meta-command inside a pipeline.

```text
\startpipeline
\g
\endpipeline
```

## Related

- [cannot use different column lists for table in different publications](./cannot-use-different-column-lists-for-table-in-different-publications.md)
- [could not send query](./could-not-send-query.md)
