---
message: "expected two-phase state data is not present in WAL at %X/%08X"
slug: expected-two-phase-state-data-is-not-present-in-wal-at
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:1454"
reproduced: false
---

# `expected two-phase state data is not present in WAL at %X/%08X`

## What it means

During recovery or two-phase-commit processing, the server expected to find the state data for a prepared transaction at a given WAL location and it was not there. The placeholder is the WAL position.

## When it happens

It fires while replaying or reading two-phase (prepared) transaction state — for example during crash recovery or when restoring prepared transactions — if the referenced WAL record is missing or the state is inconsistent.

## How to fix

This points at missing or damaged WAL for a prepared transaction rather than a user action. Confirm the WAL stream is complete and not truncated, and that recovery is reading from an intact archive. If prepared transactions were left dangling, review them with `pg_prepared_xacts`. Damaged WAL may require restoring from a consistent backup; capture the details and investigate.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected two-phase state data is not present in WAL at 0/16A2B00
```

## Related

- [expected 0 logical replication slots but found](./expected-0-logical-replication-slots-but-found.md)
- [expected end timeline but found timeline](./expected-end-timeline-but-found-timeline.md)
