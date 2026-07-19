---
message: "could not read two-phase state from WAL at %X/%08X"
slug: could-not-read-two-phase-state-from-wal-at-f64f57
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:1446"
reproduced: false
---

# `could not read two-phase state from WAL at %X/%08X`

## What it means

The server could not read the write-ahead log record that holds a prepared transaction's state at the given position. This is the variant with no trailing detail — the read simply did not return the expected record.

## When it happens

It fires while resolving prepared transactions, when the WAL record the two-phase state points at is absent or unreadable at the recorded position.

## How to fix

Ensure the WAL segment containing the prepared transaction's record is present and intact, and that recovery has replayed up to it. A missing segment means the prepared transaction cannot be reconstructed from the log; preserve the log and the transaction identifier and investigate why the WAL is not available.

## Example

*Illustrative* — the record was not readable at the position.

```text
ERROR:  could not read two-phase state from WAL at 0/1A2B3C40
```

## Related

- [could not read two-phase state from WAL (with detail)](./could-not-read-two-phase-state-from-wal-at-ccf112.md)
- [could not read WAL record](./could-not-read-wal-record.md)
