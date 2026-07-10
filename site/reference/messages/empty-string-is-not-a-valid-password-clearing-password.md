---
message: "empty string is not a valid password, clearing password"
slug: empty-string-is-not-a-valid-password-clearing-password
passthrough: false
api: [ereport]
level: [NOTICE]
call_sites:
  - "postgres/src/backend/commands/user.c:445"
  - "postgres/src/backend/commands/user.c:930"
reproduced: false
---

# `empty string is not a valid password, clearing password`

**Severity:** NOTICE

## What it means

A role was given an empty-string password, so Postgres discarded it and left the role with no password set. An empty password can never satisfy password authentication, so keeping it would be misleading; the server clears it and issues this `NOTICE`.

## When it happens

`ALTER ROLE r PASSWORD ''` (or the same on `CREATE ROLE`), usually because an application passed through a blank value from config or a form field rather than a real secret.

## Is this a problem?

If the role is meant to log in with a password, set a real one: `ALTER ROLE app PASSWORD 'new-secret'`. If it should not use password authentication at all, this is harmless — the role simply has no password and must authenticate another way (peer, cert, trust) per `pg_hba.conf`. Check for config that is feeding an empty string where a secret was intended.

## Example

*Illustrative* — assigning an empty password.

```sql
ALTER ROLE app PASSWORD '';
```

Produces:

```text
NOTICE:  empty string is not a valid password, clearing password
```

## Source

This message text is emitted from 2 call sites:

- [`postgres/src/backend/commands/user.c:445`](https://github.com/postgres/postgres/blob/master/src/backend/commands/user.c#L445) — NOTICE
- [`postgres/src/backend/commands/user.c:930`](https://github.com/postgres/postgres/blob/master/src/backend/commands/user.c#L930) — NOTICE

## Related

- [setting an MD5-encrypted password](./setting-an-md5-encrypted-password.md)
