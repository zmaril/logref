---
message: "could not receive data from client: %m"
slug: could-not-receive-data-from-client
passthrough: false
api: [ereport]
level: [COMMERROR]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:940"
  - "postgres/src/backend/libpq/pqcomm.c:1041"
reproduced: false
---

# `could not receive data from client: %m`

## What it means

The server could not receive data on a client connection. The `%m` is the operating-system error. Logged at COMMERROR, it records a broken or failed socket read rather than a query error.

## When it happens

The client disconnected abruptly, the network dropped, or a timeout or reset closed the socket while the backend waited for or read client input.

## How to fix

This usually reflects the client side or the network, not the server. Check for client crashes, aggressive timeouts, or unstable connectivity. If clients are killed mid-request, fix that; the server logs it and moves on.

## Example

*Illustrative* — the client connection was reset.

```text
LOG:  could not receive data from client: Connection reset by peer
```

## Related

- [incomplete message from client](./incomplete-message-from-client.md)
- [incomplete startup packet](./incomplete-startup-packet.md)
