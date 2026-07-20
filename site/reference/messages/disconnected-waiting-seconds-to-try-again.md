---
message: "disconnected; waiting %d seconds to try again"
slug: disconnected-waiting-seconds-to-try-again
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:922"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:1044"
reproduced: false
---

# `disconnected; waiting %d seconds to try again`

## What it means

An informational message from a client tool that it lost its connection and will wait a number of seconds before reconnecting.

## When it happens

It arises in tools that reconnect automatically (for example `pg_receivewal`/`pg_recvlogical`) when the server connection drops and the tool backs off before retrying.

## Is this a problem?

No action is needed if reconnection succeeds. If disconnects are frequent, investigate the server's availability and the network; the wait is the tool's normal backoff, not a fault in itself.

## Example

*Illustrative* — a reconnect backoff.

```text
INFO:  disconnected; waiting 5 seconds to try again
```

## Related

- [client %d receiving](./client-receiving.md)
- [received interrupt signal, exiting](./received-interrupt-signal-exiting.md)
