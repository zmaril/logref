---
message: "You must run %s as the PostgreSQL superuser."
slug: you-must-run-as-the-postgresql-superuser
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2322"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:391"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:284"
reproduced: false
---

# `You must run %s as the PostgreSQL superuser.`

## What it means

A server-side administrative tool was run as the wrong operating-system user. Tools that operate directly on a data directory must run as the operating-system account that owns the cluster's files, and the current user is not that account.

## When it happens

Running a tool such as pg_resetwal or pg_createsubscriber as the wrong OS user — often as root, or as a user other than the one that owns the data directory. Here superuser means the operating-system owner of the cluster, not a database superuser role.

## How to fix

Run the tool as the operating-system user that owns the data directory, commonly the `postgres` account. Use `su` or `sudo -u postgres` to switch to that user first. These tools refuse to run as root, and must match the file owner to operate safely.

## Example

*Illustrative* — running a server tool as the wrong OS user.

```text
pg_resetwal: error: You must run pg_resetwal as the PostgreSQL superuser.
```

## Related

- [cannot be run as root](./cannot-be-run-as-root-0ebb85.md)
- [permission denied](./permission-denied.md)
