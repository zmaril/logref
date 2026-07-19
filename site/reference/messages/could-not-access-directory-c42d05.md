---
message: "%s: could not access directory \"%s\": %m\n"
slug: could-not-access-directory-c42d05
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:1672"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:259"
reproduced: false
---

# `%s: could not access directory "%s": %m
`

## What it means

A tool or the server could not access a directory it needed — the path is missing, or permissions prevent reading it. The trailing errno string gives the operating-system reason.

## When it happens

It arises from data-directory and configuration paths (for example when validating a data directory or a tablespace location) when the directory is absent or unreadable by the server's user.

## Is this a problem?

Check the reported errno. Confirm the directory exists, is spelled correctly, and is owned by and readable/executable for the server's operating-system user. Create or fix permissions on the path, then retry.

## Example

*Illustrative* — a directory that cannot be accessed.

```text
postgres: could not access directory "/var/lib/pgsql/data": Permission denied
```

## Related

- [could not start server: %m](./could-not-start-server.md)
- [creating missing WAL directory "%s"](./creating-missing-wal-directory.md)
