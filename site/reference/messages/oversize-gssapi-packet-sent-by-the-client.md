---
message: "oversize GSSAPI packet sent by the client (%zu > %zu)"
slug: oversize-gssapi-packet-sent-by-the-client
passthrough: false
api: [ereport]
level: [COMMERROR]
call_sites:
  - "postgres/src/backend/libpq/be-secure-gssapi.c:360"
  - "postgres/src/backend/libpq/be-secure-gssapi.c:589"
reproduced: false
---

# `oversize GSSAPI packet sent by the client (%zu > %zu)`

## What it means

During a GSSAPI-encrypted connection, the client sent a packet whose declared length exceeds the maximum the server will accept. The placeholders show the offending size and the limit. The server rejects it to guard against oversize or malformed input.

## When it happens

It appears on the server side when a GSSAPI-authenticated or encrypted client sends a frame larger than the protocol allows — usually a client/library defect, a version mismatch, or corrupted/tampered traffic on the wire.

## How to fix

Confirm the client and its GSSAPI/Kerberos libraries are compatible with the server version. If the connection is being altered in transit (a proxy or middlebox), remove that interference. Persistent oversize packets from a healthy client indicate a bug worth reporting with both versions noted.

## Example

*Illustrative* — a client GSSAPI frame past the size limit.

```text
LOG:  oversize GSSAPI packet sent by the client (1049000 > 16384)
```

## Related

- [server tried to send oversize GSSAPI packet (%zu > %zu)](./server-tried-to-send-oversize-gssapi-packet.md)
- [terminating connection because protocol synchronization was lost](./terminating-connection-because-protocol-synchronization-was-lost.md)
