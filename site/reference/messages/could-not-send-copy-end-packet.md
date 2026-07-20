---
message: "could not send copy-end packet: %s"
slug: could-not-send-copy-end-packet
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/receivelog.c:1167"
  - "postgres/src/bin/pg_basebackup/receivelog.c:1207"
  - "postgres/src/bin/pg_basebackup/receivelog.c:1235"
reproduced: false
---

# `could not send copy-end packet: %s`

## What it means

A client tool (here in the base-backup/streaming path) could not send the copy-end packet that terminates a `COPY`/streaming protocol phase. The placeholder is the error detail. The connection failed while the tool was signaling the end of a data stream, so the transfer could not be completed cleanly.

## When it happens

A broken or reset connection during streaming — network failure, the server closing the connection, or a timeout — right as the tool tried to finish the copy stream.

## How to fix

Read the appended detail. Check the network path and the server log for a concurrent connection reset or error, then re-run the operation. Ensure timeouts (`statement_timeout`, network idle timeouts, load-balancer limits) are not cutting the stream short. Treat the interrupted transfer as incomplete and repeat it.

## Example

*Illustrative* — a dropped connection at stream end.

```text
pg_basebackup: error: could not send copy-end packet: ...
```

## Related

- [streaming header too small](./streaming-header-too-small.md)
- [could not send query](./could-not-send-query.md)
