---
message: "invalid SCRAM secret for user \"%s\""
slug: invalid-scram-secret-for-user
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/libpq/auth-scram.c:288"
  - "postgres/src/backend/libpq/auth-scram.c:544"
  - "postgres/src/backend/libpq/auth-scram.c:555"
reproduced: false
---

# `invalid SCRAM secret for user "%s"`

## What it means

During SCRAM authentication, the stored password verifier for the user is not a valid SCRAM secret. The server logs this and cannot authenticate the user with SCRAM, because the stored secret is malformed or not in SCRAM form.

## When it happens

A role's stored password is not a proper SCRAM verifier — for example an account whose password was set under a different scheme, was migrated inconsistently, or has an empty or corrupt verifier — while the server requires SCRAM for the login.

## Is this a problem?

Reset the user's password so a valid SCRAM secret is stored: with `password_encryption` set to `scram-sha-256`, run `ALTER ROLE ... PASSWORD '...'`. Confirm the encryption setting and re-set passwords for any accounts whose verifiers predate SCRAM or were imported incorrectly.

## Example

*Illustrative* — a malformed stored verifier.

```text
LOG:  invalid SCRAM secret for user "alice"
```

## Related

- [malformed oauth bearer token](./malformed-oauth-bearer-token.md)
- [unrecognized ssl error code](./unrecognized-ssl-error-code.md)
