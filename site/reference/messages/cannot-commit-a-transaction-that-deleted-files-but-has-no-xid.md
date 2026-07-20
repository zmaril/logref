---
message: "cannot commit a transaction that deleted files but has no xid"
slug: cannot-commit-a-transaction-that-deleted-files-but-has-no-xid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:1395"
reproduced: false
---

# `cannot commit a transaction that deleted files but has no xid`

## What it means

An internal consistency guard fired at commit: the transaction scheduled files for deletion — meaning it changed on-disk storage — yet never obtained a transaction ID. A transaction that alters storage must have an XID so its effects are recorded, so this combination is contradictory.

## When it happens

It is a can't-happen check reached at commit time. It would only surface from a bug in code that manages storage and transaction state, not from ordinary SQL.

## How to fix

There is no user-level fix. If it appears, capture the workload and any extensions in use and report it, since it points to an internal transaction-state inconsistency.

## Example

*Illustrative* — the commit-time storage guard.

```text
ERROR:  cannot commit a transaction that deleted files but has no xid
```

## Related

- [cannot apply resourceowner to non-saved cached plan](./cannot-apply-resourceowner-to-non-saved-cached-plan.md)
- [cannot change relation mapping within subtransaction](./cannot-change-relation-mapping-within-subtransaction.md)
