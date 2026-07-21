---
message: "recovery is not in progress"
slug: recovery-is-not-in-progress
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlogfuncs.c:552"
  - "postgres/src/backend/access/transam/xlogfuncs.c:582"
  - "postgres/src/backend/access/transam/xlogfuncs.c:606"
  - "postgres/src/backend/access/transam/xlogfuncs.c:629"
  - "postgres/src/backend/access/transam/xlogfuncs.c:697"
  - "postgres/src/backend/commands/wait.c:267"
  - "postgres/src/backend/commands/wait.c:276"
  - "postgres/src/backend/commands/wait.c:285"
  - "postgres/src/backend/commands/wait.c:302"
  - "postgres/src/backend/commands/wait.c:309"
  - "postgres/src/backend/commands/wait.c:316"
reproduced: false
---

# `recovery is not in progress`

## What it means

A function that only makes sense during recovery was called on a server that is not in recovery (a normal primary). The placeholder situation is the inverse of `recovery is in progress`: functions like `pg_wal_replay_pause()`/`pg_wal_replay_resume()` and `pg_promote()` require the server to be a standby replaying WAL.

## When it happens

Calling recovery-control functions on a primary — pausing/resuming WAL replay, promoting, or querying replay progress — when the server is not a standby. Also when a script assumes standby state that is not present.

## How to fix

Only call recovery-control functions on a server actually in recovery (a standby). Check `pg_is_in_recovery()` first. On a primary these functions have nothing to act on. If you expected a standby, verify the server's role and startup state.

## Example

*Illustrative* — pausing replay on a primary.

```sql
SELECT pg_wal_replay_pause();
```

Produces:

```text
ERROR:  recovery is not in progress
HINT:  Recovery control functions can only be executed during recovery.
```

## Related

- [recovery is in progress](./recovery-is-in-progress.md)
- [cannot execute %s on relation](./cannot-execute-on-relation.md)
