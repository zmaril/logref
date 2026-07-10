---
message: "permission denied for database \"%s\""
slug: permission-denied-for-database
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/utils/init/postinit.c:390"
reproduced: false
---

# `permission denied for database "%s"`

**Severity:** FATAL · SQLSTATE `42501` (ERRCODE_INSUFFICIENT_PRIVILEGE)

## What it means

A role tried to connect to (or act on) a database it lacks the `CONNECT` privilege for. This is a `FATAL` because it happens during connection startup — the session never opens. The placeholder names the database.

## When it happens

Connecting as a role that was not granted `CONNECT`, or after `CONNECT` was revoked from `PUBLIC` and not re-granted to the role. It also appears for databases restricted with `REVOKE CONNECT ON DATABASE dbname FROM PUBLIC` as part of a lockdown.

## How to fix

Grant the privilege: `GRANT CONNECT ON DATABASE dbname TO rolename` (run by an owner or superuser). Confirm the connecting role is the one you expect. If access should be broad, `GRANT CONNECT ON DATABASE dbname TO PUBLIC`. Distinguish this from authentication failures — here the credentials were accepted, but this role is not allowed into that database.

## Example

*Illustrative* — a role without CONNECT opening the database.

```sql
REVOKE CONNECT ON DATABASE app FROM lowpriv;
-- then, connecting as lowpriv:
psql -d app -U lowpriv
```

Produces:

```text
FATAL:  permission denied for database "app"
```

## Source

Emitted from [`postgres/src/backend/utils/init/postinit.c:390`](https://github.com/postgres/postgres/blob/master/src/backend/utils/init/postinit.c#L390).

## SQLSTATE

- `42501` — **ERRCODE_INSUFFICIENT_PRIVILEGE**. Class 42 (Syntax Error or Access Rule Violation).

## Related

- [no pg_hba.conf entry for host, user, database](./no-pg-hba-conf-entry-for-host-user-database.md)
- [sorry, too many clients already](./sorry-too-many-clients-already.md)
- [relation "%s" does not exist](./relation-does-not-exist-d06d8d.md)
