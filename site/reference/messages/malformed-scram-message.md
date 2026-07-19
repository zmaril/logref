---
message: "malformed SCRAM message"
slug: malformed-scram-message
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:378"
  - "postgres/src/backend/libpq/auth-scram.c:383"
  - "postgres/src/backend/libpq/auth-scram.c:747"
  - "postgres/src/backend/libpq/auth-scram.c:755"
  - "postgres/src/backend/libpq/auth-scram.c:860"
  - "postgres/src/backend/libpq/auth-scram.c:873"
  - "postgres/src/backend/libpq/auth-scram.c:883"
  - "postgres/src/backend/libpq/auth-scram.c:991"
  - "postgres/src/backend/libpq/auth-scram.c:998"
  - "postgres/src/backend/libpq/auth-scram.c:1013"
  - "postgres/src/backend/libpq/auth-scram.c:1028"
  - "postgres/src/backend/libpq/auth-scram.c:1042"
  - "postgres/src/backend/libpq/auth-scram.c:1060"
  - "postgres/src/backend/libpq/auth-scram.c:1075"
  - "postgres/src/backend/libpq/auth-scram.c:1388"
  - "postgres/src/backend/libpq/auth-scram.c:1396"
reproduced: false
---

# `malformed SCRAM message`

## What it means

During SCRAM (`SCRAM-SHA-256`) authentication, the client sent a message the server could not parse per the SCRAM protocol. The challenge/response exchange is strictly framed, and a message that does not fit the expected format is rejected as a protocol violation.

## When it happens

A client driver with a broken or outdated SCRAM implementation, a corrupted or truncated auth packet, an intervening proxy that altered the exchange, or a mismatch where the client attempts SCRAM incorrectly.

## How to fix

Update the client library to one with correct, current SCRAM support (very old drivers predate SCRAM). Verify no proxy or connection pooler is interfering with the SASL exchange. If only some clients fail, the problem is in that client's driver, not the server.

## Example

*Illustrative* — a client sending a non-conforming SCRAM message.

```text
ERROR:  malformed SCRAM message
DETAIL:  Invalid channel binding flag.
```

## Related

- [malformed OAUTHBEARER message](./malformed-oauthbearer-message.md)
- [role %s does not exist](./role-does-not-exist.md)
