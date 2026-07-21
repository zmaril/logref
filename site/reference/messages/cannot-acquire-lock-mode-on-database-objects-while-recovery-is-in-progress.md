---
message: "cannot acquire lock mode %s on database objects while recovery is in progress"
slug: cannot-acquire-lock-mode-on-database-objects-while-recovery-is-in-progress
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:865"
reproduced: false
---

# `cannot acquire lock mode %s on database objects while recovery is in progress`

## What it means

A session on a standby, or during recovery, tried to take a lock strong enough to be disallowed while recovery is running. The placeholder is the lock mode. Recovery permits only lock modes compatible with read-only replay.

## When it happens

It occurs when a query or command on a hot standby requests a lock mode beyond what read-only access allows, such as one implied by a write or by certain maintenance commands.

## How to fix

Run the operation on the primary. Standbys are read-only during recovery and cannot grant the stronger lock modes that writes and many DDL and maintenance commands require.

## Example

*Illustrative* — a strong lock requested on a standby.

```text
ERROR:  cannot acquire lock mode AccessExclusiveLock on database objects while recovery is in progress
```

## Related

- [cannot access temporary or unlogged relations during recovery](./cannot-access-temporary-or-unlogged-relations-during-recovery.md)
- [canceling autovacuum task](./canceling-autovacuum-task.md)
