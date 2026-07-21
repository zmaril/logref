---
message: "could not find record while sending logically-decoded data: %s"
slug: could-not-find-record-while-sending-logically-decoded-data
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/walsender.c:3685"
reproduced: false
---

# `could not find record while sending logically-decoded data: %s`

## What it means

While streaming logically-decoded changes, the walsender could not read a WAL record it expected. The `%s` gives extra detail. This is an internal guard reached during logical replication output.

## When it happens

It fires when the walsender processes WAL for a logical replication stream and a needed record is missing or unreadable. It generally accompanies an unusual WAL state.

## How to fix

This is an internal error. Check the server log for surrounding WAL or replication messages and the health of the slot and WAL. Note the slot and workload and report a reproducible case if it recurs.

## Example

*Illustrative* — a missing record while streaming decoded data.

```text
ERROR:  could not find record while sending logically-decoded data: ...detail...
```

## Related

- [could not find record while advancing replication slot](./could-not-find-record-while-advancing-replication-slot.md)
- [could not find logical decoding starting point](./could-not-find-logical-decoding-starting-point-9f53a0.md)
