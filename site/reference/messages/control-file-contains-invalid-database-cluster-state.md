---
message: "control file contains invalid database cluster state"
slug: control-file-contains-invalid-database-cluster-state
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:5935"
reproduced: false
---

# `control file contains invalid database cluster state`

## What it means

At startup, the server read `pg_control` and found the cluster-state field set to a value it does not recognize. The state must be one of the known values (starting up, in production, shut down, and so on), so an invalid one is fatal. This points to control-file damage.

## When it happens

It happens during startup when `pg_control`'s `state` value is corrupted or was written by an incompatible version.

## How to fix

Treat this as control-file corruption. Restore from a good backup, and ensure the binary version matches the data directory. `pg_resetwal` can rewrite the control file as a last resort but risks data loss; use it only knowingly.

## Example

*Illustrative* — an invalid cluster-state value at startup.

```text
FATAL:  control file contains invalid database cluster state
```

## Related

- [control file contains invalid checkpoint location](./control-file-contains-invalid-checkpoint-location.md)
- [corrupted two-phase state file for transaction of epoch](./corrupted-two-phase-state-file-for-transaction-of-epoch.md)
