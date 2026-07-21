---
message: "malformed OAuth bearer token"
slug: malformed-oauth-bearer-token
passthrough: false
api: [ereport]
level: [COMMERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/libpq/auth-oauth.c:617"
  - "postgres/src/backend/libpq/auth-oauth.c:634"
  - "postgres/src/backend/libpq/auth-oauth.c:656"
reproduced: false
---

# `malformed OAuth bearer token`

## What it means

During OAuth-based authentication, the server received a bearer token that does not conform to the expected format. The token could not be parsed as a well-formed OAuth bearer credential, so authentication was refused at the protocol level.

## When it happens

A client using the OAuth authentication flow sent a token that is empty, wrongly framed, or otherwise not shaped like a valid bearer token — usually a client-side or token-issuer configuration problem rather than a wrong-but-valid credential.

## How to fix

Check how the client obtains and formats the bearer token. Verify the token issuer and the client library produce a standards-compliant bearer token, that it is passed intact without truncation, and that the server's OAuth validator configuration matches the issuer. Capture the client-side token acquisition path when debugging.

## Example

*Illustrative* — a token the server could not parse.

```text
LOG:  malformed OAuth bearer token
```

## Related

- [malformed scram message](./malformed-scram-message.md)
- [invalid scram secret for user](./invalid-scram-secret-for-user.md)
