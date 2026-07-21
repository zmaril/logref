---
message: "missing lock for relation \"%s\" (OID %u, relkind %c) @ TID (%u,%u)"
slug: missing-lock-for-relation-oid-relkind-tid
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:4241"
  - "postgres/src/backend/access/heap/heapam.c:4294"
reproduced: false
---

# `missing lock for relation "%s" (OID %u, relkind %c) @ TID (%u,%u)`

## What it means

Internal warning. A consistency check found that a relation was being touched at a given tuple without the lock the code expected to be held on it.

## When it happens

It fires from lock-assertion checks (often in assert-enabled or hardened builds) when the expected relation lock is absent. Ordinary operation does not produce it.

## Is this a problem?

This is an internal consistency warning that points to a locking-protocol issue. If it appears during normal activity, capture the relation, workload, and any extensions and report it as a reproducible bug.

## Example

*Illustrative* — a missing relation lock.

```text
WARNING:  missing lock for relation "orders" (OID 16401, relkind r) @ TID (0,1)
```

## Related

- [concurrent delete in progress within table "%s"](./concurrent-delete-in-progress-within-table.md)
- [wrong pg_constraint entry for trigger "%s" on table "%s"](./wrong-pg-constraint-entry-for-trigger-on-table.md)
