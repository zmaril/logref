---
message: "cannot assign MultiXactIds during recovery"
slug: cannot-assign-multixactids-during-recovery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/multixact.c:988"
reproduced: false
---

# `cannot assign MultiXactIds during recovery`

## What it means

A backend tried to allocate a new MultiXactId while the server was in recovery. MultiXactIds record sets of transactions sharing a row lock, and only a system processing its own write-ahead log may allocate them — a server replaying WAL must not.

## When it happens

It is a low-level guard reached when something attempts a row-lock operation that would consume a MultiXactId on a standby or during crash recovery. Read-only work is normally rejected earlier with a read-only-transaction error.

## How to fix

Do not attempt writes on a standby or before recovery completes. If this fires from ordinary use, capture the statement and the recovery state, since reaching this guard suggests a deeper issue than a plain read-only rejection.

## Example

*Illustrative* — MultiXact allocation during recovery.

```text
ERROR:  cannot assign MultiXactIds during recovery
```

## Related

- [cannot assign oids during recovery](./cannot-assign-oids-during-recovery.md)
- [cannot assign transactionids during recovery](./cannot-assign-transactionids-during-recovery.md)
