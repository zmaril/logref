---
message: "password encryption failed: %s"
slug: password-encryption-failed
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/libpq/crypt.c:204"
  - "postgres/src/bin/scripts/createuser.c:311"
reproduced: false
---

# `password encryption failed: %s`

## What it means

The server could not encrypt a role password into the configured hash format. The placeholder carries the underlying reason. The plaintext could not be turned into the stored SCRAM or MD5 verifier.

## When it happens

It arises during `CREATE ROLE`/`ALTER ROLE ... PASSWORD` when the encryption routine fails — for example a cryptographic library problem, an out-of-memory condition, or an unusable value for the chosen `password_encryption` method.

## How to fix

Check the reason in the message and the server log. Confirm `password_encryption` is set to a supported method (`scram-sha-256` is the modern default) and that the server's cryptographic support is intact. Retrying after resolving a transient resource issue usually succeeds.

## Example

*Illustrative* — password hashing failing during role creation.

```text
ERROR:  password encryption failed: out of memory
```

## Related

- [password is required](./password-is-required.md)
- [role name "%s" contains a newline or carriage return character](./role-name-contains-a-newline-or-carriage-return-character.md)
