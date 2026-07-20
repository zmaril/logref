---
message: "the database system is not yet accepting connections"
slug: the-database-system-is-not-yet-accepting-connections
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_CANNOT_CONNECT_NOW
    code: "57P03"
call_sites:
  - "postgres/src/backend/tcop/backend_startup.c:318"
  - "postgres/src/backend/tcop/backend_startup.c:325"
reproduced: false
---

# `the database system is not yet accepting connections`

## What it means

The server is running but not yet ready to accept client connections. It is still in startup or recovery — replaying WAL, waiting to reach a consistent state, or completing initialization. The connection is refused until it is ready.

## When it happens

It arises when clients connect during startup: crash recovery after an unclean shutdown, a standby that has not yet reached a consistent recovery point, or the brief window while a normal start completes.

## How to fix

Wait and retry; the message usually includes a detail about what it is waiting for. For long recoveries, monitor progress in the server log. If it never becomes ready, investigate the recovery/startup detail (missing WAL, a stuck restore command, or a standby waiting on the primary).

## Example

*Illustrative* — connecting before recovery finishes.

```text
FATAL:  the database system is not yet accepting connections
DETAIL:  Consistent recovery state has not been yet reached.
```

## Related

- [pre-existing shared memory block (key %lu, ID %lu) is still in use](./pre-existing-shared-memory-block-key-id-is-still-in-use.md)
- [standby promotion is ongoing](./standby-promotion-is-ongoing.md)
