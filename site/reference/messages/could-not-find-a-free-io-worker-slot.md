---
message: "could not find a free IO worker slot"
slug: could-not-find-a-free-io-worker-slot
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:4526"
reproduced: false
---

# `could not find a free IO worker slot`

## What it means

The postmaster could not find a free slot to launch an I/O worker process. This is an internal guard on the fixed-size table of I/O worker slots.

## When it happens

It fires when the asynchronous-I/O subsystem tries to start a worker and every slot is already taken. Reaching it points at an internal accounting problem rather than a configuration the user set directly.

## How to fix

This is an internal error. If it recurs, note the `io_workers` setting and the workload that triggered it and report a reproducible case. There is no ordinary user action that should reach this guard.

## Example

*Illustrative* — no free I/O worker slot.

```text
ERROR:  could not find a free IO worker slot
```

## Related

- [could not find entry in sinval array](./could-not-find-entry-in-sinval-array.md)
- [could not find just referenced shared stats entry](./could-not-find-just-referenced-shared-stats-entry.md)
