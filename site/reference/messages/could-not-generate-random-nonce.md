---
message: "could not generate random nonce"
slug: could-not-generate-random-nonce
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1236"
reproduced: false
---

# `could not generate random nonce`

## What it means

During SCRAM authentication the server tried to create a random nonce and the random source failed. A nonce is a fresh random value each handshake uses so the exchange cannot be replayed.

## When it happens

It fires while a client authenticates with SCRAM (the default password method), when the server cannot obtain random bytes for the nonce — usually a broken or unavailable entropy source.

## How to fix

Make sure the host provides working randomness to the server and that its SSL/crypto library is healthy. Once the entropy source works, authentication proceeds normally. This is an environment problem, not a wrong password.

## Example

*Illustrative* — the SCRAM nonce could not be generated.

```text
ERROR:  could not generate random nonce
```

## Related

- [could not generate random salt](./could-not-generate-random-salt.md)
- [could not generate random cancel key](./could-not-generate-random-cancel-key.md)
