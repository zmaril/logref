---
message: "sorry, too many clients already"
slug: sorry-too-many-clients-already
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_TOO_MANY_CONNECTIONS
    code: "53300"
call_sites:
  - "postgres/src/backend/storage/ipc/procarray.c:482"
  - "postgres/src/backend/storage/lmgr/proc.c:458"
  - "postgres/src/backend/tcop/backend_startup.c:341"
reproduced: true
---

# `sorry, too many clients already`

## What it means

The server has reached `max_connections` and cannot accept another backend. Each connection reserves a slot (and a small block of shared memory); when all slots are taken, new connections are rejected with this `FATAL` until one frees up. Some slots are reserved for superusers and replication, so ordinary connections can be refused while a few reserved ones remain.

## When it happens

Connection demand exceeds `max_connections` — a burst of traffic, a connection leak in the application, or many short-lived connections opened without pooling. It also appears when idle-in-transaction sessions pile up and never release their slots.

## How to fix

First find what is holding connections: `SELECT count(*), state FROM pg_stat_activity GROUP BY state` — a large `idle` or `idle in transaction` count points at a leak or a missing pooler. The durable fix is a connection pooler (PgBouncer, or your framework's pool) so the app multiplexes over a small set of backends. Raising `max_connections` helps short-term but each connection costs memory, so pooling scales better. Terminate stuck sessions with `pg_terminate_backend(pid)` if needed.

## Example

*Reproduced* — captured by `reproducers/env-run.sh` (scenario `tier4__resource_timeouts`). The site emits a background log record; the captured line was:

```text
FATAL:  sorry, too many clients already
```

## Related

- [connection received: host, port](./connection-received-host-port.md)
- [permission denied for database](./permission-denied-for-database.md)
