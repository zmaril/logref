---
message: "data directory \"%s\" has wrong ownership"
slug: data-directory-has-wrong-ownership
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:335"
reproduced: false
---

# `data directory "%s" has wrong ownership`

## What it means

At startup the server found that the data directory is not owned by the operating-system user running the server. The placeholder is the directory. Postgres requires the data directory to be owned by the account the server runs as.

## When it happens

It fires when the postmaster starts and the data directory's owner differs from the effective user of the server process — usually after copying or restoring the directory under the wrong account.

## How to fix

Change ownership of the data directory to the account the server runs as (typically `postgres`): `chown -R postgres:postgres <datadir>`. Start the server as that same user. Ownership mismatches often follow a restore done as root.

## Example

*Illustrative* — the data directory is owned by the wrong user.

```text
FATAL:  data directory "/var/lib/postgresql/data" has wrong ownership
HINT:  The server must be started by the user that owns the data directory.
```

## Related

- [data directory has invalid permissions](./data-directory-has-invalid-permissions.md)
- [database user is not the install user](./database-user-is-not-the-install-user.md)
