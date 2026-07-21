---
message: "cannot export a snapshot from within a transaction"
slug: cannot-export-a-snapshot-from-within-a-transaction
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:548"
reproduced: false
---

# `cannot export a snapshot from within a transaction`

## What it means

An internal guard in the logical-decoding snapshot builder fired: it was asked to export a snapshot while a transaction was already in progress in a context that forbids it. The snapshot-export path in snapshot building expects to run outside an open transaction.

## When it happens

It is reached inside logical-decoding setup when the snapshot builder exports a consistent snapshot at the wrong point in the transaction lifecycle. It reflects an internal sequencing issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the logical-replication or decoding-plugin setup that triggered it and report it, since snapshot export here is driven by the decoding machinery.

## Example

*Illustrative* — snapshot export at the wrong transaction point.

```text
ERROR:  cannot export a snapshot from within a transaction
```

## Related

- [cannot export a snapshot from a subtransaction](./cannot-export-a-snapshot-from-a-subtransaction.md)
- [cannot free an active snapshot](./cannot-free-an-active-snapshot.md)
