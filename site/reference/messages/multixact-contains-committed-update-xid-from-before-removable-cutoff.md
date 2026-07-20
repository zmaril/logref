---
message: "multixact %u contains committed update XID %u from before removable cutoff %u"
slug: multixact-contains-committed-update-xid-from-before-removable-cutoff
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6743"
  - "postgres/src/backend/access/heap/heapam.c:6927"
reproduced: false
---

# `multixact %u contains committed update XID %u from before removable cutoff %u`

## What it means

During vacuum or freeze processing, a multixact member referenced a committed update transaction id older than the cutoff below which such ids should already be gone. It signals data corruption in the transaction/multixact bookkeeping.

## When it happens

It arises in `VACUUM`/`FREEZE` when scanning tuples whose multixact membership points at an update xid that predates the removable cutoff — a state that should not occur and usually indicates corrupted `pg_multixact` or clog data.

## How to fix

Treat this as possible corruption. Stop routine writes to the affected table, take a physical backup, and review the log for related errors. Determine the extent with careful, read-only inspection; recovery may require restoring from a known-good backup. Investigate the storage and any recent crash history, and preserve diagnostics before acting.

## Example

*Illustrative* — a stale update xid inside a multixact.

```text
ERROR:  multixact 42 contains committed update XID 100 from before removable cutoff 200
```

## Related

- [no relation entry for relid](./no-relation-entry-for-relid.md)
- [null conbin for relation](./null-conbin-for-relation.md)
