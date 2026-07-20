---
message: "%s(%s) failed: %m"
slug: failed-6aec9d
passthrough: false
api: [ereport]
level: [FATAL, LOG]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:212"
  - "postgres/src/backend/libpq/pqcomm.c:220"
  - "postgres/src/backend/libpq/pqcomm.c:251"
  - "postgres/src/backend/libpq/pqcomm.c:260"
  - "postgres/src/backend/libpq/pqcomm.c:1651"
  - "postgres/src/backend/libpq/pqcomm.c:1696"
  - "postgres/src/backend/libpq/pqcomm.c:1736"
  - "postgres/src/backend/libpq/pqcomm.c:1780"
  - "postgres/src/backend/libpq/pqcomm.c:1819"
  - "postgres/src/backend/libpq/pqcomm.c:1858"
  - "postgres/src/backend/libpq/pqcomm.c:1894"
  - "postgres/src/backend/libpq/pqcomm.c:1933"
reproduced: false
---

# `%s(%s) failed: %m`

## What it means

A named system or library call failed and the message reports the call, its argument, and the OS error. The first two placeholders are the function name and its argument; `%m` is the `errno` text. This shape is used in the networking/communication layer (`pqcomm`) to report a specific socket or system call that failed.

## When it happens

Low-level connection handling — a `setsockopt`, `bind`, `listen`, or similar call failing during postmaster startup or connection setup. The `%m` names the underlying reason (for example `Address already in use`, `Permission denied`).

## How to fix

Read the function name and `%m` together. `Address already in use` on a listen socket means another process holds the port — stop it or change `port`/`listen_addresses`. `Permission denied` binding a low port or a Unix socket directory is an ownership/permission problem. The named call tells you which operation to investigate.

## Example

*Illustrative* — a listen socket whose port is taken.

```text
LOG:  bind(AF_INET) failed: Address already in use
```

## Related

- [%s() failed: %m](./failed-f29774.md)
- [could not open file](./could-not-open-file-420e05.md)
