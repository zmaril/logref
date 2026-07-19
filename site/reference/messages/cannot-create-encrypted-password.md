---
message: "cannot create encrypted password"
slug: cannot-create-encrypted-password
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/contrib/pgcrypto/crypt-sha.c:638"
reproduced: false
---

# `cannot create encrypted password`

## What it means

A tool such as `createuser` or a client routine could not build an encrypted password value. The chosen password encryption method could not be applied — for example a required algorithm is unavailable in the build.

## When it happens

It occurs when creating or setting a role's password with an encryption method the client or server cannot perform.

## How to fix

Use a supported password encryption method — typically SCRAM — and a build that includes the needed cryptographic support. Check the `password_encryption` setting and the tool's options.

## Example

*Illustrative* — password encryption unavailable.

```text
error: cannot create encrypted password
```

## Related

- [cannot encrypt password with 'plaintext'](./cannot-encrypt-password-with-plaintext.md)
- [cannot create temporary directory](./cannot-create-temporary-directory.md)
