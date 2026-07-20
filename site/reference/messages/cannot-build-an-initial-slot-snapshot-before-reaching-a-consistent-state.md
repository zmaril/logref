---
message: "cannot build an initial slot snapshot before reaching a consistent state"
slug: cannot-build-an-initial-slot-snapshot-before-reaching-a-consistent-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:462"
reproduced: false
---

# `cannot build an initial slot snapshot before reaching a consistent state`

## What it means

Logical decoding was asked to export an initial snapshot before the slot had reached a consistent starting point. The decoder must first observe enough write-ahead log to know a complete set of running transactions before it can produce a usable snapshot.

## When it happens

It occurs when snapshot export is requested too early in a logical slot's initialization, before the consistent-point handshake completes.

## How to fix

Wait for the slot to reach its consistent point, then export the snapshot. When using replication protocol commands, follow the documented `CREATE_REPLICATION_SLOT ... EXPORT_SNAPSHOT` sequence rather than requesting a snapshot up front.

## Example

*Illustrative* — snapshot requested too early.

```text
ERROR:  cannot build an initial slot snapshot before reaching a consistent state
```

## Related

- [cannot build an initial slot snapshot not all transactions are monitored anymore](./cannot-build-an-initial-slot-snapshot-not-all-transactions-are-monitored-anymore.md)
- [cannot build an initial slot snapshot when myproc xmin already is valid](./cannot-build-an-initial-slot-snapshot-when-myproc-xmin-already-is-valid.md)
