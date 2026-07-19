---
message: "tuple concurrently deleted"
slug: tuple-concurrently-deleted
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:3180"
  - "postgres/src/backend/access/heap/heapam.c:4478"
  - "postgres/src/backend/access/table/tableam.c:343"
  - "postgres/src/backend/access/table/tableam.c:392"
reproduced: false
---

# `tuple concurrently deleted`

## What it means

Internal error. Code that expected to operate on a specific catalog or heap tuple found it had been deleted by another transaction in the meantime. The placeholder-free message is a low-level concurrency guard; it usually surfaces around concurrent DDL on the same object.

## When it happens

Two sessions performing overlapping DDL/maintenance on the same object, so one deletes the tuple the other was about to update. It reflects a race the caller did not fully serialize rather than a data error.

## How to fix

Retry the operation — on retry the object state is re-read and the race usually resolves. If it recurs reliably, serialize the conflicting DDL (avoid running the same `ALTER`/maintenance concurrently from multiple sessions). Persistent, non-concurrent cases are worth reporting with a reproducer.

## Example

*Illustrative* — a tuple deleted by a concurrent transaction.

```text
ERROR:  tuple concurrently deleted
```

## Related

- [tuple concurrently updated](./tuple-concurrently-updated.md)
- [could not obtain lock on relation](./could-not-obtain-lock-on-relation-da8ac5.md)
