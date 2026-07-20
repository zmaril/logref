---
message: "cannot build an initial slot snapshot, not all transactions are monitored anymore"
slug: cannot-build-an-initial-slot-snapshot-not-all-transactions-are-monitored-anymore
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:465"
reproduced: false
---

# `cannot build an initial slot snapshot, not all transactions are monitored anymore`

## What it means

Logical decoding could not build an initial snapshot because it is no longer tracking every transaction the snapshot would need. Some in-progress transactions fell out of the decoder's monitored set before a consistent snapshot could be formed.

## When it happens

It occurs during logical-slot initialization when the set of running transactions changed in a way that leaves the snapshot builder unable to account for all of them.

## How to fix

Retry the snapshot build; the decoder can usually reach a consistent state on a subsequent attempt. Reduce competing long-running transactions during slot creation so the tracked set stays complete.

## Example

*Illustrative* — the monitored-set guard.

```text
ERROR:  cannot build an initial slot snapshot, not all transactions are monitored anymore
```

## Related

- [cannot build an initial slot snapshot before reaching a consistent state](./cannot-build-an-initial-slot-snapshot-before-reaching-a-consistent-state.md)
- [cannot build an initial slot snapshot as oldest safe xid follows snapshot's xmin](./cannot-build-an-initial-slot-snapshot-as-oldest-safe-xid-follows-snapshot-s-xmin.md)
