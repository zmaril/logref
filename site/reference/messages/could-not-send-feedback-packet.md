---
message: "could not send feedback packet: %s"
slug: could-not-send-feedback-packet
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:172"
  - "postgres/src/bin/pg_basebackup/receivelog.c:360"
reproduced: false
---

# `could not send feedback packet: %s`

## What it means

`pg_recvlogical` or the WAL receiver in `pg_basebackup` could not send a feedback packet to the server. The `%s` is the connection error. Feedback keeps the server's flush/apply position current.

## When it happens

The replication connection broke or errored while the client sent a standby status update — a dropped network, a server restart, or a closed socket.

## How to fix

Check the connection between the client and server and the server's availability. Restart the streaming client; it resumes from the last confirmed position. Persistent failures point at the network or server.

## Example

*Illustrative* — feedback failed on a broken connection.

```text
pg_recvlogical: error: could not send feedback packet: server closed the connection unexpectedly
```

## Related

- [disconnected](./disconnected.md)
- [could not write to file](./could-not-write-to-file-209f23.md)
