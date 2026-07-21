---
message: "could not get server certificate hash"
slug: could-not-get-server-certificate-hash
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:1330"
reproduced: false
---

# `could not get server certificate hash`

## What it means

During SCRAM authentication with channel binding, the server tried to obtain the hash of its own TLS certificate and could not. That hash binds the authenticated session to the specific TLS connection.

## When it happens

It fires while a client authenticates with SCRAM channel binding over SSL, when the server cannot compute or retrieve its certificate hash — usually a certificate the SSL library cannot digest as expected.

## How to fix

This is an internal guard around the SSL layer. Confirm the server certificate is valid and uses an algorithm the linked OpenSSL supports, and that SSL is configured correctly. Replacing a problematic certificate usually resolves it; capture the log if it recurs on a known-good certificate.

## Example

*Illustrative* — the server certificate hash could not be obtained.

```text
ERROR:  could not get server certificate hash
```

## Related

- [could not generate server certificate hash](./could-not-generate-server-certificate-hash.md)
- [could not hash stored key](./could-not-hash-stored-key.md)
