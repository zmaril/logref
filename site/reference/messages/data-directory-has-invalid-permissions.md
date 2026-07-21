---
message: "data directory \"%s\" has invalid permissions"
slug: data-directory-has-invalid-permissions
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:355"
reproduced: false
---

# `data directory "%s" has invalid permissions`

## What it means

At startup the server found the data directory's filesystem permissions too permissive. The placeholder is the directory. The data directory must be accessible only to its owner (and optionally the group), not to everyone.

## When it happens

It fires when the postmaster starts and the data directory allows access to other users beyond what Postgres permits — for example world-readable permissions.

## How to fix

Tighten the permissions on the data directory so only the owner has access: `chmod 700 <datadir>` (or `750` if you use group access with the matching cluster setting). Then restart the server. Postgres refuses to start with an over-exposed data directory to protect its files.

## Example

*Illustrative* — the data directory is world-accessible.

```text
FATAL:  data directory "/var/lib/postgresql/data" has invalid permissions
DETAIL:  Permissions should be u=rwx (0700) or u=rwx,g=rx (0750).
```

## Related

- [data directory has wrong ownership](./data-directory-has-wrong-ownership.md)
- [could not read lock file](./could-not-read-lock-file.md)
