---
message: "cannot assign OIDs during recovery"
slug: cannot-assign-oids-during-recovery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:560"
reproduced: false
---

# `cannot assign OIDs during recovery`

## What it means

A backend tried to allocate a new object identifier (OID) while the server was in recovery. OID allocation advances a shared counter that only a system processing its own write-ahead log may move, so it is forbidden while replaying WAL.

## When it happens

It is a low-level guard reached when an operation that would consume an OID runs on a standby or during crash recovery. Ordinary writes are normally rejected earlier as read-only.

## How to fix

Do not run OID-consuming operations on a standby or before recovery finishes. If it fires from normal use, capture the statement and recovery state, since reaching this guard points to a deeper problem than a plain read-only rejection.

## Example

*Illustrative* — OID allocation during recovery.

```text
ERROR:  cannot assign OIDs during recovery
```

## Related

- [cannot assign multixactids during recovery](./cannot-assign-multixactids-during-recovery.md)
- [cannot assign transactionids during recovery](./cannot-assign-transactionids-during-recovery.md)
