---
message: "incomplete message from client"
slug: incomplete-message-from-client
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:1247"
  - "postgres/src/backend/libpq/pqcomm.c:1260"
reproduced: false
---

# `incomplete message from client`

## What it means

The server received a protocol message from a client that ended before it was complete. Logged at COMMERROR, it records a truncated or malformed wire message rather than a query error.

## When it happens

A client disconnected mid-message, sent a malformed frame, or the network truncated the data, while the backend read a protocol message.

## How to fix

This usually reflects the client or network, not the server. Check for client crashes, buggy client protocol handling, or connectivity problems. A non-Postgres client speaking the wrong protocol can also cause it.

## Example

*Illustrative* — a truncated client message.

```text
LOG:  incomplete message from client
```

## Related

- [incomplete startup packet](./incomplete-startup-packet.md)
- [could not receive data from client](./could-not-receive-data-from-client.md)
