---
message: "empty password returned by client"
slug: empty-password-returned-by-client
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PASSWORD
    code: "28P01"
call_sites:
  - "postgres/src/backend/libpq/auth.c:770"
reproduced: false
---

# `empty password returned by client`

## What it means

During authentication, the client sent an empty password. PostgreSQL rejects empty passwords for password-based authentication methods regardless of what is stored.

## When it happens

It fires during `password`, `md5`, or SCRAM authentication when the client supplies a zero-length password.

## How to fix

Supply a non-empty password. Check that the client is actually sending a password (a missing `PGPASSWORD`, `.pgpass` entry, or prompt response yields an empty one). Set a real password for the role with `ALTER ROLE ... PASSWORD`.

## Example

*Illustrative* — an empty password at login.

```text
ERROR:  empty password returned by client
```

## Related

- [encrypted password is too long](./encrypted-password-is-too-long.md)
- [EmitConnectionWarnings() called more than once](./emitconnectionwarnings-called-more-than-once.md)
