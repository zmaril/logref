---
message: "could not encode SCRAM server key"
slug: could-not-encode-scram-server-key
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/dblink/dblink.c:3233"
  - "postgres/contrib/postgres_fdw/connection.c:604"
reproduced: false
---

# `could not encode SCRAM server key`

## What it means

SCRAM code in `dblink` or `postgres_fdw` could not base64-encode the SCRAM server key during pass-through authentication to a remote server. The encoding of the derived key failed, halting the pass-through SCRAM exchange.

## When it happens

Connecting through `dblink` or `postgres_fdw` with SCRAM pass-through authentication when the server-key encoding step fails — an internal or cryptographic-backend fault.

## How to fix

Treat it as an internal error in the SCRAM pass-through path. Check the cryptographic backend, capture the foreign-connection context, and report it. Review the SCRAM pass-through setup on both servers if it persists.

## Example

*Illustrative* — a SCRAM server key that could not be encoded.

```text
ERROR:  could not encode SCRAM server key
```

## Related

- [could not encode SCRAM client key](./could-not-encode-scram-client-key.md)
- [could not encode salt](./could-not-encode-salt.md)
