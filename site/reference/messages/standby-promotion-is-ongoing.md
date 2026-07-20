---
message: "standby promotion is ongoing"
slug: standby-promotion-is-ongoing
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/access/transam/xlogfuncs.c:558"
  - "postgres/src/backend/access/transam/xlogfuncs.c:588"
reproduced: false
---

# `standby promotion is ongoing`

## What it means

An operation was refused because the standby it targeted is in the middle of being promoted to a primary. During promotion the server is transitioning out of recovery, so certain requests cannot be honored.

## When it happens

It arises when issuing a command that conflicts with an in-progress promotion — for example another promotion request, or a recovery-control action while `pg_promote`/trigger-based promotion is already underway.

## How to fix

Wait for the promotion to finish, then retry. Do not issue overlapping promotion or recovery-control commands. Monitor `pg_is_in_recovery()` to confirm when the server has finished becoming a primary.

## Example

*Illustrative* — an action during an active promotion.

```text
ERROR:  standby promotion is ongoing
```

## Related

- [the standby was promoted during online backup](./the-standby-was-promoted-during-online-backup.md)
- [terminating connection due to conflict with recovery](./terminating-connection-due-to-conflict-with-recovery.md)
