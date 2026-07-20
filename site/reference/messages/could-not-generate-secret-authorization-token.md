---
message: "could not generate secret authorization token"
slug: could-not-generate-secret-authorization-token
passthrough: false
api: [ereport]
level: [PANIC]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:4265"
reproduced: false
---

# `could not generate secret authorization token`

## What it means

The server tried to create the secret authorization token used to coordinate background processes and the random source failed. This token authenticates internal, backend-to-backend requests.

## When it happens

It fires during startup or WAL setup, at the highest severity, when the server cannot obtain the random bytes for the token — usually a broken or unavailable system entropy source at a point where the server cannot continue.

## How to fix

Make sure the host provides working randomness to the server process before it starts, and that its crypto library is healthy. Restore access to the system random source and start the server again; this is an environment problem, not a data problem.

## Example

*Illustrative* — the internal authorization token could not be generated.

```text
PANIC:  could not generate secret authorization token
```

## Related

- [could not generate a random number](./could-not-generate-a-random-number.md)
- [could not generate random cancel key](./could-not-generate-random-cancel-key.md)
