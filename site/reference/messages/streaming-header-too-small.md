---
message: "streaming header too small: %d"
slug: streaming-header-too-small
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:483"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:534"
  - "postgres/src/bin/pg_basebackup/receivelog.c:1017"
  - "postgres/src/bin/pg_basebackup/receivelog.c:1080"
reproduced: false
---

# `streaming header too small: %d`

## What it means

A streaming-replication client (here `pg_recvlogical`) received a message from the server whose header was shorter than the protocol's minimum. The placeholder is the actual length. Each replication message begins with a fixed-size header; a header below that size means the stream is truncated or the peer is not speaking the expected protocol.

## When it happens

A corrupted or cut-off replication stream, a network middlebox mangling the connection, or a version/protocol mismatch between the client tool and the server.

## How to fix

Check the connection and versions: make sure the client tool matches the server major version, and that nothing (proxy, load balancer) is altering the replication stream. Retry the stream; if it recurs, capture the server log around the same time and inspect for a connection reset or a server-side error that truncated the message.

## Example

*Illustrative* — a truncated replication message.

```text
pg_recvlogical: error: streaming header too small: 3
```

## Related

- [could not send copy-end packet](./could-not-send-copy-end-packet.md)
- [subscription could not connect to the publisher](./subscription-could-not-connect-to-the-publisher.md)
