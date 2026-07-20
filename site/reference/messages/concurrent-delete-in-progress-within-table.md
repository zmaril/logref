---
message: "concurrent delete in progress within table \"%s\""
slug: concurrent-delete-in-progress-within-table
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/heap/heapam_handler.c:828"
  - "postgres/src/backend/access/heap/heapam_handler.c:1507"
reproduced: false
---

# `concurrent delete in progress within table "%s"`

## What it means

A warning that a maintenance operation observed a row being deleted by another transaction that had not yet committed within the table it was processing.

## When it happens

It arises during operations such as `VACUUM FULL`/`CLUSTER` or logical-decoding snapshot building when a concurrent uncommitted delete is seen. The operation handles it and continues.

## Is this a problem?

Usually no action is needed — it reports a normal concurrency interaction. If it recurs with a specific maintenance job, note the concurrent workload; a repeated warning can indicate contention worth scheduling around.

## Example

*Illustrative* — a concurrent delete seen during maintenance.

```text
WARNING:  concurrent delete in progress within table "orders"
```

## Related

- [concurrent insert in progress within table "%s"](./concurrent-insert-in-progress-within-table.md)
- [missing lock for relation "%s" (OID %u, relkind %c) @ TID (%u,%u)](./missing-lock-for-relation-oid-relkind-tid.md)
