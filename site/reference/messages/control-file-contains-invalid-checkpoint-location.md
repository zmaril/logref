---
message: "control file contains invalid checkpoint location"
slug: control-file-contains-invalid-checkpoint-location
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:5877"
reproduced: false
---

# `control file contains invalid checkpoint location`

## What it means

At startup, the server read `pg_control` and found the recorded checkpoint location invalid. The control file is the anchor for recovery, so an invalid checkpoint pointer stops startup with a fatal error. This usually means the control file or WAL is damaged.

## When it happens

It happens during server startup when `pg_control` holds a checkpoint LSN that does not point at a valid record, often after corruption, a truncated file, or a mismatched/partial data directory.

## How to fix

Treat this as data-directory damage. Restore from a known-good backup, or if you understand the risks, use `pg_resetwal` only as a last resort (it can cause data loss and requires careful follow-up). Do not run the cluster normally until the control file and WAL are consistent.

## Example

*Illustrative* — an invalid checkpoint pointer at startup.

```text
FATAL:  control file contains invalid checkpoint location
```

## Related

- [control file contains invalid database cluster state](./control-file-contains-invalid-database-cluster-state.md)
- [corrupted two-phase state file for transaction of epoch](./corrupted-two-phase-state-file-for-transaction-of-epoch.md)
