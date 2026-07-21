---
message: "could not create any TCP/IP sockets"
slug: could-not-create-any-tcp-ip-sockets
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1185"
reproduced: true
---

# `could not create any TCP/IP sockets`

## What it means

The postmaster was configured to listen on TCP/IP but could not open a listening socket on any of the requested addresses. Startup cannot continue without a way to accept connections.

## When it happens

It happens at server startup when every address in `listen_addresses` fails to bind — commonly because the port is already in use, or the addresses are not present on the host.

## How to fix

Check that the configured `port` is free (another PostgreSQL instance or process may hold it) and that every address in `listen_addresses` exists on this host. Adjust `listen_addresses`/`port` and restart. Earlier log lines name the specific bind failure per address.

## Example

*Reproduced* — captured by `reproducers/env-run.sh` (scenario `tier4__crash_recovery`). The site emits a background log record; the captured line was:

```text
FATAL:  could not create any TCP/IP sockets
```

## Related

- [could not create any Unix-domain sockets](./could-not-create-any-unix-domain-sockets.md)
- [could not create lock file](./could-not-create-lock-file.md)
