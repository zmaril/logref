---
message: "password or GSSAPI delegated credentials required"
slug: password-or-gssapi-delegated-credentials-required
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_S_R_E_PROHIBITED_SQL_STATEMENT_ATTEMPTED
    code: "2F003"
call_sites:
  - "postgres/contrib/dblink/dblink.c:2714"
  - "postgres/contrib/dblink/dblink.c:2781"
  - "postgres/contrib/postgres_fdw/connection.c:482"
  - "postgres/contrib/postgres_fdw/connection.c:793"
reproduced: false
---

# `password or GSSAPI delegated credentials required`

## What it means

A connection made on behalf of the current session (for example by `dblink` or `postgres_fdw`) was refused because it carried no password and no delegated GSSAPI credentials. To stop a non-superuser from borrowing the server's ambient authentication, outbound connections from these modules must authenticate with a credential the user actually supplied.

## When it happens

A non-superuser opens a `dblink`/`postgres_fdw` connection to a server whose authentication would otherwise succeed via `trust`, `peer`, or the server's own identity — none of which prove the connecting user's identity — and no password or delegated GSSAPI credential is present.

## How to fix

Provide a real credential on the outbound connection: put a `password` in the user mapping (or the `dblink` conninfo), or use GSSAPI credential delegation so the user's own Kerberos ticket is forwarded. Superusers are exempt; for non-superusers, requiring the password is a deliberate safety rule, so supply one rather than trying to bypass it.

## Example

*Illustrative* — a passwordless FDW connection by a non-superuser.

```text
ERROR:  password or GSSAPI delegated credentials required
```

## Related

- [could not send query](./could-not-send-query.md)
- [subscription could not connect to the publisher](./subscription-could-not-connect-to-the-publisher.md)
