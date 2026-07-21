---
message: "connection received: host=%s port=%s"
slug: connection-received-host-port
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/tcop/backend_startup.c:225"
reproduced: true
---

# `connection received: host=%s port=%s`

## What it means

The postmaster accepted an incoming TCP connection and is beginning to set up a backend for it. The placeholders record the client host and source port. This is logged before authentication, so it marks arrival, not a successful login. A companion form logs Unix-socket connections without a port.

## When it happens

Emitted for each new connection when `log_connections` is enabled. A matching `connection authorized` line follows once authentication succeeds; if none does, the connection was rejected or dropped between arrival and login.

## Is this a problem?

Informational — no action required. It is valuable for auditing and for diagnosing connection storms: a flood of `connection received` lines without matching authorizations can indicate a scanner, a health check hammering the port, or an application opening and dropping connections. Correlate the host and port with `pg_stat_activity` when tracing a specific client.

## Example

*Reproduced* — captured by `reproducers/env-run.sh` (scenario `tier4__replication_standby`). The site emits a background log record; the captured line was:

```text
LOG:  connection received: host=127.0.0.1 port=59746
```

## Related

- [sorry, too many clients already](./sorry-too-many-clients-already.md)
- [database system is ready to accept connections](./database-system-is-ready-to-accept-connections.md)
