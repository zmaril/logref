---
message: "server tried to send oversize GSSAPI packet (%zu > %zu)"
slug: server-tried-to-send-oversize-gssapi-packet
passthrough: false
api: [ereport]
level: [COMMERROR]
call_sites:
  - "postgres/src/backend/libpq/be-secure-gssapi.c:224"
  - "postgres/src/backend/libpq/be-secure-gssapi.c:648"
reproduced: false
---

# `server tried to send oversize GSSAPI packet (%zu > %zu)`

## What it means

On a GSSAPI-encrypted connection, the server was about to send a packet larger than the protocol's maximum, so it aborted the send. The placeholders show the size and the limit. This is the server-side counterpart to the oversize-client-packet check.

## When it happens

It arises when a server-produced GSSAPI frame would exceed the size cap — usually indicating a bug or an unexpected message size in the GSSAPI transport, rather than normal operation.

## How to fix

Confirm the server and client GSSAPI/Kerberos libraries are compatible and current. A reproducible oversize send is worth reporting with versions and the triggering operation, as it points to a transport-layer defect.

## Example

*Illustrative* — the server refusing to emit an oversize GSSAPI frame.

```text
LOG:  server tried to send oversize GSSAPI packet (1049000 > 16384)
```

## Related

- [oversize GSSAPI packet sent by the client (%zu > %zu)](./oversize-gssapi-packet-sent-by-the-client.md)
- [SSL error: %s](./ssl-error.md)
