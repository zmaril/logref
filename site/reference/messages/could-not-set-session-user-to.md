---
message: "could not set session user to \"%s\": %s"
slug: could-not-set-session-user-to
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:3522"
reproduced: false
---

# `could not set session user to "%s": %s`

## What it means

During a restore, `pg_restore` could not switch the session's user to the role an object should be created as. The placeholder is the role name and the trailing text is the server's error. The tool sets the session authorization so objects get the right owner.

## When it happens

It fires while restoring, when a `SET SESSION AUTHORIZATION` to a role fails — the role does not exist on the target, or the connected user lacks the right to become it.

## How to fix

Make sure the roles the dump references exist on the target cluster before restoring, for example by restoring globals from `pg_dumpall --globals-only` first. The user running the restore must be a superuser, or otherwise able to set session authorization to those roles. Alternatively restore with `--no-owner` to skip ownership changes.

## Example

*Illustrative* — the target role was missing.

```text
pg_restore: error: could not set session user to "appowner": role "appowner" does not exist
```

## Related

- [could not set replication progress for subscription](./could-not-set-replication-progress-for-subscription.md)
- [database user is not the install user](./database-user-is-not-the-install-user.md)
