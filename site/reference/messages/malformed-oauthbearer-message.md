---
message: "malformed OAUTHBEARER message"
slug: malformed-oauthbearer-message
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth-oauth.c:177"
  - "postgres/src/backend/libpq/auth-oauth.c:182"
  - "postgres/src/backend/libpq/auth-oauth.c:201"
  - "postgres/src/backend/libpq/auth-oauth.c:241"
  - "postgres/src/backend/libpq/auth-oauth.c:251"
  - "postgres/src/backend/libpq/auth-oauth.c:260"
  - "postgres/src/backend/libpq/auth-oauth.c:275"
  - "postgres/src/backend/libpq/auth-oauth.c:284"
  - "postgres/src/backend/libpq/auth-oauth.c:293"
  - "postgres/src/backend/libpq/auth-oauth.c:300"
  - "postgres/src/backend/libpq/auth-oauth.c:385"
  - "postgres/src/backend/libpq/auth-oauth.c:392"
  - "postgres/src/backend/libpq/auth-oauth.c:418"
  - "postgres/src/backend/libpq/auth-oauth.c:463"
  - "postgres/src/backend/libpq/auth-oauth.c:481"
  - "postgres/src/backend/libpq/auth-oauth.c:495"
  - "postgres/src/backend/libpq/auth-oauth.c:515"
reproduced: false
---

# `malformed OAUTHBEARER message`

## What it means

During OAuth (`OAUTHBEARER`) authentication, the client sent a message that did not follow the SASL OAUTHBEARER framing. The server could not parse the token exchange, so authentication is refused as a protocol violation.

## When it happens

A client library that implements OAUTHBEARER incorrectly, a truncated or corrupted auth message, a version mismatch between client and server OAuth support, or a proxy that mangled the SASL exchange.

## How to fix

Update the client driver to a version with correct OAUTHBEARER support and confirm it is sending a well-formed initial client response and token. Check that no proxy is altering the authentication traffic. Compare against a working client to isolate whether the fault is in the driver or the token provider.

## Example

*Illustrative* — a client sending a non-conforming OAuth message.

```text
ERROR:  malformed OAUTHBEARER message
```

## Related

- [malformed SCRAM message](./malformed-scram-message.md)
- [out of memory](./out-of-memory-6bf5c2.md)
