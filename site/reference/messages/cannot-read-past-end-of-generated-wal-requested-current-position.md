---
message: "cannot read past end of generated WAL: requested %X/%08X, current position %X/%08X"
slug: cannot-read-past-end-of-generated-wal-requested-current-position
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:1808"
reproduced: false
---

# `cannot read past end of generated WAL: requested %X/%08X, current position %X/%08X`

## What it means

A read of the write-ahead log requested a position beyond the WAL that has been generated so far. The requested LSN lies past the current insert position, so there is nothing to read there. The placeholders are the requested and current LSNs.

## When it happens

It is reached when a WAL reader — a replication or decoding consumer — asks for a position ahead of what the server has written. It usually points to a bookkeeping issue in the consumer rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the replication or decoding client and the two LSNs and report it. Confirm the consumer is not requesting positions it has not yet been told exist.

## Example

*Illustrative* — a read past the end of WAL.

```text
ERROR:  cannot read past end of generated WAL: requested 0/16A2B10, current position 0/16A2000
```

## Related

- [cannot get the latest WAL position from the publisher](./cannot-get-the-latest-wal-position-from-the-publisher.md)
- [cannot retrieve commit timestamp for transaction](./cannot-retrieve-commit-timestamp-for-transaction.md)
