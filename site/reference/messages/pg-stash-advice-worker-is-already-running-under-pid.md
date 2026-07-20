---
message: "pg_stash_advice worker is already running under PID %d"
slug: pg-stash-advice-worker-is-already-running-under-pid
passthrough: false
api: [ereport]
level: [ERROR, LOG]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/pg_stash_advice/stashfuncs.c:339"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:131"
reproduced: false
---

# `pg_stash_advice worker is already running under PID %d`

## What it means

A background worker associated with the `pg_stash` advice feature was asked to start while an instance is already running. The placeholder is the PID of the existing worker. Only one such worker may run at a time.

## When it happens

It arises when a start request for this worker is issued while a prior one is still active — for example a duplicate launch, or a start attempted before the previous worker exited. It is reported as an error to the requester and logged.

## How to fix

Do not start a second worker; the one already running (at the reported PID) is handling the work. If the existing worker is stuck, investigate or stop it before launching a replacement. This concerns a specific extension/worker; consult its documentation for lifecycle control.

## Example

*Illustrative* — a duplicate start of the advice worker.

```text
ERROR:  pg_stash_advice worker is already running under PID 41213
```

## Related

- [advice stash does not exist](./advice-stash-does-not-exist.md)
- [replication slot "%s" is active for PID %d](./replication-slot-is-active-for-pid.md)
