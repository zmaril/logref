---
message: "logical replication column %d not found in tuple: only %d column(s) received"
slug: logical-replication-column-not-found-in-tuple-only-column-s-received
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:1044"
  - "postgres/src/backend/replication/logical/worker.c:1161"
  - "postgres/src/backend/replication/logical/worker.c:2884"
reproduced: false
---

# `logical replication column %d not found in tuple: only %d column(s) received`

## What it means

A logical replication apply worker expected a column at a given position in an incoming row, but the row it received from the publisher had fewer columns. The subscriber's idea of the table shape does not match what arrived on the wire.

## When it happens

A schema mismatch between publisher and subscriber for a replicated table — columns added or dropped on one side but not the other, or a replica identity or column list that leaves the two sides disagreeing about how many columns each row carries.

## How to fix

Reconcile the table definitions on both sides. Make sure the subscriber's table has the columns the publication sends, in a compatible order, and refresh the subscription (`ALTER SUBSCRIPTION ... REFRESH PUBLICATION`) after schema changes. Check any publication column list and the replica identity so both ends agree on the row shape.

## Example

*Illustrative* — a subscriber expecting more columns than arrived.

```text
ERROR:  logical replication column 4 not found in tuple: only 3 column(s) received
```

## Related

- [no replication origin is configured](./no-replication-origin-is-configured.md)
- [unexpected termination of replication stream](./unexpected-termination-of-replication-stream.md)
