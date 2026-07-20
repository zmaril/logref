---
message: "could not read two-phase state from WAL at %X/%08X: %s"
slug: could-not-read-two-phase-state-from-wal-at-ccf112
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:1441"
reproduced: false
---

# `could not read two-phase state from WAL at %X/%08X: %s`

## What it means

The server tried to read the stored state of a prepared (two-phase) transaction back out of the write-ahead log and the read failed. The placeholder is the WAL position, and the trailing text is the reason the read reported.

## When it happens

It fires during recovery or `COMMIT PREPARED`/`ROLLBACK PREPARED` handling, when the record describing a prepared transaction cannot be read from the WAL at the position the two-phase machinery recorded.

## How to fix

This points at missing or damaged WAL covering the prepared transaction. Make sure the WAL range holding the two-phase record is intact and, on a standby, that replay has reached it. If the WAL is genuinely gone, the prepared transaction cannot be resolved from the log; capture the log and the transaction identifier before taking recovery action.

## Example

*Illustrative* — the two-phase record could not be read.

```text
ERROR:  could not read two-phase state from WAL at 0/1A2B3C40: invalid record length
```

## Related

- [could not read two-phase state from WAL (no detail)](./could-not-read-two-phase-state-from-wal-at-f64f57.md)
- [could not read WAL record](./could-not-read-wal-record.md)
