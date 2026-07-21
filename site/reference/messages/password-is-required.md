---
message: "password is required"
slug: password-is-required
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_S_R_E_PROHIBITED_SQL_STATEMENT_ATTEMPTED
    code: "2F003"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:244"
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:336"
reproduced: false
---

# `password is required`

## What it means

An operation that mandates a password was attempted without one. Postgres refuses it because allowing a passwordless path here would let a less-privileged actor use the server's own credentials or bypass authentication.

## When it happens

It commonly arises with `dblink`, `postgres_fdw`, and similar connectors: a non-superuser must supply a password in the connection so the remote side authenticates them, rather than relying on the server's ambient identity (peer, trust, or a service file).

## How to fix

Include a password in the user mapping or connection string for the outgoing connection. For `postgres_fdw`, set the `password` option on the `CREATE USER MAPPING`. Superusers can be exempted in some cases, but the intended fix is to provide the credential explicitly.

## Example

*Illustrative* — a foreign connection made by a non-superuser without a password.

```text
ERROR:  password is required
DETAIL:  Non-superusers must provide a password in the user mapping.
```

## Related

- [password encryption failed: %s](./password-encryption-failed.md)
- [subscription owner "%s" does not have permission on foreign server "%s"](./subscription-owner-does-not-have-permission-on-foreign-server.md)
