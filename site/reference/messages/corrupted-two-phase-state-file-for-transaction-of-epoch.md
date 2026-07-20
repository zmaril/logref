---
message: "corrupted two-phase state file for transaction %u of epoch %u"
slug: corrupted-two-phase-state-file-for-transaction-of-epoch
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/transam/twophase.c:2270"
reproduced: false
---

# `corrupted two-phase state file for transaction %u of epoch %u`

## What it means

During recovery or two-phase-commit processing, the on-disk state file for a prepared transaction was found corrupted. The prepared transaction's record cannot be read, which blocks its resolution.

## When it happens

It happens at startup recovery or when processing prepared transactions if a file under `pg_twophase` is damaged or truncated.

## How to fix

Treat this as corruption of the two-phase state. If you can identify and safely discard the prepared transaction, remove the bad state after understanding the consequences; otherwise restore from a consistent backup. Investigate storage integrity, since the file was damaged.

## Example

*Illustrative* — a corrupted prepared-transaction state file.

```text
ERROR:  corrupted two-phase state file for transaction 8912 of epoch 3
```

## Related

- [corrupted two-phase state in memory for transaction of epoch](./corrupted-two-phase-state-in-memory-for-transaction-of-epoch.md)
- [control file contains invalid checkpoint location](./control-file-contains-invalid-checkpoint-location.md)
