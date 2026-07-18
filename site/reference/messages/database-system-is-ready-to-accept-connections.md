---
message: "database system is ready to accept connections"
slug: database-system-is-ready-to-accept-connections
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:2359"
reproduced: false
---

# `database system is ready to accept connections`

## What it means

Startup is complete: the postmaster has finished recovery (if any) and is now listening for client connections. This single `LOG` line is the canonical "the server is up" signal — scripts and orchestrators often wait for it before considering the database healthy.

## When it happens

Logged once per server start, after crash or archive recovery finishes and the postmaster opens for normal (read-write) connections. A separate line, `database system is ready to accept read-only connections`, marks a hot standby opening for read-only queries.

## Is this a problem?

Nothing to do — this is the good news line. Its absence is what matters: if the log ends during recovery without reaching this message, startup stalled or failed, and the lines just above it explain why. Use it as the readiness marker in health checks and startup scripts.

## Related

- [connection received: host, port](./connection-received-host-port.md)
- [could not locate a valid checkpoint record](./could-not-locate-a-valid-checkpoint-record-at.md)
