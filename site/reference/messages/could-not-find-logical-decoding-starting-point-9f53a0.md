---
message: "could not find logical decoding starting point"
slug: could-not-find-logical-decoding-starting-point-9f53a0
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:647"
reproduced: false
---

# `could not find logical decoding starting point`

## What it means

Logical decoding could not establish a consistent starting point from which to begin decoding. This is an internal guard reached when the snapshot builder does not reach consistency.

## When it happens

It fires during logical-decoding setup when the process cannot settle on a start LSN and snapshot. It generally accompanies an unusual WAL or slot state rather than ordinary decoding.

## How to fix

This is an internal error. Check the server log for surrounding replication messages and the health of the replication slot involved. Note the slot and workload and report a reproducible case if it recurs.

## Example

*Illustrative* — no consistent decoding start point.

```text
ERROR:  could not find logical decoding starting point
```

## Related

- [could not find logical decoding starting point (with detail)](./could-not-find-logical-decoding-starting-point-6967b9.md)
- [could not find record while sending logically-decoded data](./could-not-find-record-while-sending-logically-decoded-data.md)
