---
message: "invalid socket: %s"
slug: invalid-socket-871fdb
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:381"
  - "postgres/src/bin/pg_basebackup/receivelog.c:896"
  - "postgres/src/bin/pgbench/pgbench.c:7650"
  - "postgres/src/bin/pgbench/pgbench.c:7737"
reproduced: false
---

# `invalid socket: %s`

## What it means

A tool (here `pg_recvlogical`) found its connection socket in an invalid state when it went to wait on it. The placeholder is the detail. The socket underlying the server connection was not usable for the poll/select the tool needed to perform.

## When it happens

A streaming client's connection was closed or entered a bad state unexpectedly, so the socket it tried to wait on is no longer valid — usually following a dropped or reset connection.

## How to fix

This is generally a symptom of a lost connection rather than a configuration error. Check server availability and network stability, review the tool's earlier output for the disconnect cause, and restart the stream. If it recurs, capture the surrounding logs and report it.

## Example

*Illustrative* — an unusable socket after a dropped connection.

```text
ERROR:  invalid socket
```

## Related

- [could not receive data from WAL stream](./could-not-receive-data-from-wal-stream.md)
- [could not establish connection](./could-not-establish-connection.md)
