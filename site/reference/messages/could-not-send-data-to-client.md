---
message: "could not send data to client: %m"
slug: could-not-send-data-to-client
passthrough: false
api: [ereport]
level: [COMMERROR]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:1403"
reproduced: false
---

# `could not send data to client: %m`

## What it means

The server could not send data to a connected client. The trailing text is the operating-system error. This is logged as a communication error because the failure is on the network path, not in the query.

## When it happens

It fires when the server writes results or messages to a client whose connection has gone away — the client disconnected, a proxy timed out, or the network dropped.

## How to fix

This usually means the client vanished before the server finished sending. It is normal to see it occasionally with clients that disconnect early or with idle-timeout proxies. If it is frequent, look at the network path, connection poolers, and client-side timeouts between the application and the database.

## Example

*Illustrative* — the client connection was gone.

```text
LOG:  could not send data to client: Broken pipe
```

## Related

- [could not send tuple to shared-memory queue](./could-not-send-tuple-to-shared-memory-queue.md)
- [could not set socket to nonblocking mode](./could-not-set-socket-to-nonblocking-mode.md)
