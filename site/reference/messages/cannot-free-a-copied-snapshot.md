---
message: "cannot free a copied snapshot"
slug: cannot-free-a-copied-snapshot
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:269"
  - "postgres/src/backend/replication/logical/snapbuild.c:348"
reproduced: false
---

# `cannot free a copied snapshot`

## What it means

Internal error. Snapshot-management code in logical decoding was asked to free a snapshot that is a copy rather than an owned original. Copied snapshots are released differently, so freeing one directly is a bookkeeping violation.

## When it happens

It should not occur through ordinary use. Reaching it points to an internal inconsistency in the logical-decoding snapshot builder, not to anything in your replication configuration.

## How to fix

Treat it as an internal bug. Capture the logical-decoding or replication context in which it fired and report it. There is no user-side change expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally by the snapshot builder.

```text
ERROR:  cannot free a copied snapshot
```

## Related

- [cannot perform logical decoding without an acquired slot](./cannot-perform-logical-decoding-without-an-acquired-slot.md)
- [could not find record for logical decoding](./could-not-find-record-for-logical-decoding.md)
