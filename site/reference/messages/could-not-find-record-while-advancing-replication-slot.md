---
message: "could not find record while advancing replication slot: %s"
slug: could-not-find-record-while-advancing-replication-slot
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:2156"
reproduced: false
---

# `could not find record while advancing replication slot: %s`

## What it means

While advancing a replication slot, logical decoding could not read a WAL record it expected. The `%s` gives extra detail. This is an internal guard reached during `pg_replication_slot_advance`.

## When it happens

It fires when advancing a logical slot forward and a needed WAL record is missing or unreadable at the position being processed. It generally accompanies an unusual WAL state.

## How to fix

This is an internal error. Check the server log for surrounding WAL or replication messages and the health of the slot and WAL. Note the slot and target LSN and report a reproducible case if it recurs.

## Example

*Illustrative* — a missing record while advancing a slot.

```text
ERROR:  could not find record while advancing replication slot: ...detail...
```

## Related

- [could not find record while sending logically-decoded data](./could-not-find-record-while-sending-logically-decoded-data.md)
- [could not find logical decoding starting point](./could-not-find-logical-decoding-starting-point-9f53a0.md)
