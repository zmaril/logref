---
message: "could not find record for logical decoding: %s"
slug: could-not-find-record-for-logical-decoding
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:2048"
  - "postgres/src/backend/replication/logical/logicalfuncs.c:259"
reproduced: false
---

# `could not find record for logical decoding: %s`

## What it means

Logical decoding tried to read a specific WAL record and could not find or read it. The placeholder is the underlying reason. The WAL location the decoder needed was unavailable — removed, unreadable, or beyond what is retained.

## When it happens

Decoding changes from a logical slot when the required WAL has already been recycled (the slot fell behind and WAL was removed), the WAL file is missing or damaged, or a read error occurs.

## How to fix

Check the detail for the cause. Ensure WAL needed by logical slots is retained — keep slots consumed so they do not lag, and size `max_slot_wal_keep_size` appropriately. If the required WAL is gone, the slot may need to be dropped and the subscription re-synchronized. Investigate any WAL file read error at the storage level.

## Example

*Illustrative* — WAL missing for a decoding slot.

```text
ERROR:  could not find record for logical decoding: requested WAL segment has already been removed
```

## Related

- [cannot perform logical decoding without an acquired slot](./cannot-perform-logical-decoding-without-an-acquired-slot.md)
- [could not find redo location referenced by checkpoint record at](./could-not-find-redo-location-referenced-by-checkpoint-record-at.md)
