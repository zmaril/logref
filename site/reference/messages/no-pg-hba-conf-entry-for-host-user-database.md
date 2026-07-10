---
message: "no pg_hba.conf entry for host \"%s\", user \"%s\", database \"%s\", %s"
slug: no-pg-hba-conf-entry-for-host-user-database
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_AUTHORIZATION_SPECIFICATION
    code: "28000"
call_sites:
  - "postgres/src/backend/libpq/auth.c:536"
reproduced: false
---

# `no pg_hba.conf entry for host "%s", user "%s", database "%s", %s`

**Severity:** FATAL · SQLSTATE `28000` (ERRCODE_INVALID_AUTHORIZATION_SPECIFICATION)

## What it means

The client-authentication file `pg_hba.conf` has no rule that matches this connection attempt. Postgres checks each incoming connection against ordered host-based rules keyed on source host, requested user, and database; when none matches, the connection is refused before any password is even considered. The placeholders echo the host, user, database, and the negotiated encryption method.

## When it happens

Connecting from an IP range, as a user, or to a database that no `pg_hba.conf` line covers — often a new application host, a new user, or an SSL/non-SSL mismatch. A frequent cause is that `pg_hba.conf` was edited but never reloaded.

## How to fix

Add a matching line to `pg_hba.conf` — for example `host  app  appuser  10.0.0.0/24  scram-sha-256` — then reload the server (`SELECT pg_reload_conf()` or `pg_ctl reload`); edits do not take effect until a reload. Order matters: the first matching rule wins, so a broad reject line above your rule will shadow it. Check the `%s` method token in the message (for example `SSL off`) — a rule may require SSL that the client did not use. `SELECT * FROM pg_hba_file_rules` shows the parsed rules and any load errors.

## Example

*Illustrative* — a host not covered by any rule.

```text
# pg_hba.conf has only:
#   host  all  all  127.0.0.1/32  scram-sha-256
# a client at 10.0.0.5 connects:
```

Produces:

```text
FATAL:  no pg_hba.conf entry for host "10.0.0.5", user "appuser", database "app", no encryption
```

## Source

Emitted from [`postgres/src/backend/libpq/auth.c:536`](https://github.com/postgres/postgres/blob/master/src/backend/libpq/auth.c#L536).

## SQLSTATE

- `28000` — **ERRCODE_INVALID_AUTHORIZATION_SPECIFICATION**. Class 28 (Invalid Authorization Specification).

## Related

- [permission denied for database](./permission-denied-for-database.md)
- [sorry, too many clients already](./sorry-too-many-clients-already.md)
