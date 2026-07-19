---
message: "incomplete startup packet"
slug: incomplete-startup-packet
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/tcop/backend_startup.c:534"
  - "postgres/src/backend/tcop/backend_startup.c:562"
reproduced: false
---

# `incomplete startup packet`

## What it means

The server received a startup packet that ended before it was complete. Logged at COMMERROR, it records a connection that opened and closed (or truncated) before finishing the handshake.

## When it happens

A health check or port scanner opened and closed the socket, a client aborted before sending the full startup packet, or the network truncated it. Empty TCP probes commonly cause this.

## How to fix

Usually harmless. If it comes from monitoring or load-balancer health checks, point them at the `/health`-style probe or expect the log line. Investigate only if it correlates with real clients failing to connect.

## Example

*Illustrative* — a probe that closed before the handshake.

```text
LOG:  incomplete startup packet
```

## Related

- [incomplete message from client](./incomplete-message-from-client.md)
- [could not receive data from client](./could-not-receive-data-from-client.md)
