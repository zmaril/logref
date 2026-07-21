---
message: "connection to client lost"
slug: connection-to-client-lost
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:3555"
reproduced: false
---

# `connection to client lost`

## What it means

The backend lost its connection to the client while processing. The client went away (crashed, timed out, or closed the socket), so the session cannot continue and terminates.

## When it happens

It happens mid-query or between queries when the network connection to the client is broken, for example due to a client crash, a dropped network link, or an aggressive firewall/idle timeout.

## How to fix

Investigate why the client disconnected: application crashes, network instability, or proxy/firewall idle timeouts are common causes. Add TCP keepalives, raise idle timeouts on intermediaries, and ensure the client stays connected for the duration of its work.

## Example

*Illustrative* — a backend losing its client.

```text
FATAL:  connection to client lost
```

## Related

- [connection to server was lost](./connection-to-server-was-lost.md)
- [connection requires a valid client certificate](./connection-requires-a-valid-client-certificate.md)
