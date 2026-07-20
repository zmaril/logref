---
message: "could not generate random cancel key"
slug: could-not-generate-random-cancel-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:4458"
reproduced: false
---

# `could not generate random cancel key`

## What it means

When setting up a session, the backend tried to create the random cancel key that lets a client cancel its own running query and the random source failed. Each connection is issued a secret key for exactly this purpose.

## When it happens

It fires during connection startup, when the server cannot obtain the random bytes for the cancel key — usually a broken or unavailable system entropy source.

## How to fix

Make sure the host provides working randomness to the server process and that the crypto library it uses is healthy. Once the entropy source is restored, new connections will succeed. Persistent failures point at a misconfigured environment for the kernel random device.

## Example

*Illustrative* — the cancel key could not be generated.

```text
ERROR:  could not generate random cancel key
```

## Related

- [could not generate a random number](./could-not-generate-a-random-number.md)
- [could not generate random nonce](./could-not-generate-random-nonce.md)
