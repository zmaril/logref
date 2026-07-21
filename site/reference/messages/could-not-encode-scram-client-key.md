---
message: "could not encode SCRAM client key"
slug: could-not-encode-scram-client-key
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/dblink/dblink.c:3224"
  - "postgres/contrib/postgres_fdw/connection.c:593"
reproduced: false
---

# `could not encode SCRAM client key`

## What it means

SCRAM code in `dblink` or `postgres_fdw` could not base64-encode the SCRAM client key while passing through authentication to a remote server. The encoding of the derived key failed, so the pass-through SCRAM exchange could not continue.

## When it happens

Connecting through `dblink` or `postgres_fdw` with SCRAM pass-through authentication when the client-key encoding step fails — an internal or cryptographic-backend fault.

## How to fix

Treat it as an internal error in the SCRAM pass-through path. Verify the cryptographic backend is healthy, capture the foreign-connection context, and report it. Confirm the SCRAM pass-through configuration on both ends if it recurs.

## Example

*Illustrative* — a SCRAM client key that could not be encoded.

```text
ERROR:  could not encode SCRAM client key
```

## Related

- [could not encode SCRAM server key](./could-not-encode-scram-server-key.md)
- [could not encode salt](./could-not-encode-salt.md)
