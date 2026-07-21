---
message: "encrypted password is too long"
slug: encrypted-password-is-too-long
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/libpq/crypt.c:235"
reproduced: false
---

# `encrypted password is too long`

## What it means

A password (in its encrypted/hashed form) exceeded the maximum length PostgreSQL stores for a role's password. The pre-hashed or supplied value is longer than the fixed limit.

## When it happens

It fires from `CREATE ROLE`/`ALTER ROLE ... PASSWORD` when a pre-encrypted password string is supplied that is longer than the storage limit, or when hashing produces an over-length value.

## How to fix

Supply a plain password and let the server hash it (the SCRAM/MD5 output fits the limit), rather than passing an over-long pre-encrypted string. If you are passing a pre-hashed value, make sure it is a correctly formatted SCRAM or MD5 verifier, not arbitrary text.

## Example

*Illustrative* — an over-long pre-encrypted password.

```sql
ALTER ROLE app PASSWORD 'md5<very long invalid string>';
-- encrypted password is too long
```

## Related

- [empty password returned by client](./empty-password-returned-by-client.md)
- [EmitConnectionWarnings() called more than once](./emitconnectionwarnings-called-more-than-once.md)
