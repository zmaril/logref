---
message: "could not open lock file \"%s\": %m"
slug: could-not-open-lock-file
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:1247"
reproduced: false
---

# `could not open lock file "%s": %m`

## What it means

The server tried to open a lock file that guards a data directory or socket and the operating system refused. The `%m` reason gives the cause. Lock files keep two servers from using the same directory or socket.

## When it happens

It fires at startup, at high severity, when a lock file cannot be opened — usually a permissions problem on the data directory or socket location, or a path that does not exist.

## How to fix

Make sure the data directory and any socket directory are present and owned by, and writable by, the server's operating-system user. Fixing the permissions or path, then starting the server again, resolves it.

## Example

*Illustrative* — a lock file could not be opened.

```text
FATAL:  could not open lock file "/var/run/postgresql/.s.PGSQL.5432.lock": Permission denied
```

## Related

- [could not map anonymous shared memory](./could-not-map-anonymous-shared-memory.md)
- [could not open critical system index](./could-not-open-critical-system-index.md)
