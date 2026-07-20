---
message: "could not create any Unix-domain sockets"
slug: could-not-create-any-unix-domain-sockets
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1276"
reproduced: false
---

# `could not create any Unix-domain sockets`

## What it means

The postmaster was configured to use Unix-domain sockets but could not create one in any of the requested directories. Startup cannot continue without a listening socket.

## When it happens

It happens at startup when every directory in `unix_socket_directories` fails — a missing directory, wrong permissions, or a stale socket file left by a crash.

## How to fix

Confirm each directory in `unix_socket_directories` exists and is writable by the server user, and remove any stale socket file from a prior crash. Earlier log lines name the specific failure per directory.

## Example

*Illustrative* — no socket directory was usable.

```text
FATAL:  could not create any Unix-domain sockets
```

## Related

- [could not create any TCP/IP sockets](./could-not-create-any-tcp-ip-sockets.md)
- [could not create lock file](./could-not-create-lock-file.md)
