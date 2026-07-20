---
message: "cannot encrypt password with 'plaintext'"
slug: cannot-encrypt-password-with-plaintext
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/crypt.c:212"
reproduced: false
---

# `cannot encrypt password with 'plaintext'`

## What it means

A password operation requested the `plaintext` method where an actual encryption method is required. `plaintext` means no encryption, so it cannot be used where the code expects to encrypt the password.

## When it happens

It occurs in a client or tool that maps a password-encryption choice, when `plaintext` is supplied for an operation that must produce an encrypted verifier.

## How to fix

Choose a real encryption method such as SCRAM (`scram-sha-256`) rather than `plaintext`. Set the tool or `password_encryption` to a supported encrypting method.

## Example

*Illustrative* — plaintext where encryption is required.

```text
error: cannot encrypt password with 'plaintext'
```

## Related

- [cannot create encrypted password](./cannot-create-encrypted-password.md)
- [cannot escape without active connection](./cannot-escape-without-active-connection.md)
