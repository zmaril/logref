---
message: "tuple concurrently updated"
slug: tuple-concurrently-updated
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:3176"
  - "postgres/src/backend/access/heap/heapam.c:4474"
  - "postgres/src/backend/access/table/tableam.c:339"
  - "postgres/src/backend/access/table/tableam.c:388"
reproduced: false
---

# `tuple concurrently updated`

## What it means

Internal error. Code that expected to update a specific catalog or heap tuple found it had already been updated by another transaction. The message is a concurrency guard, most often seen when overlapping DDL touches the same catalog row.

## When it happens

Concurrent DDL or maintenance on one object from multiple sessions — for example two `ALTER`s, or an `ALTER` racing a background operation — so one updates the row the other was about to change.

## How to fix

Retry the statement; the object is re-read and the update usually succeeds. To avoid it entirely, serialize the conflicting DDL so only one session mutates a given object at a time. Report reproducible cases that are not explained by concurrent DDL.

## Example

*Illustrative* — a tuple updated by a concurrent transaction.

```text
ERROR:  tuple concurrently updated
```

## Related

- [tuple concurrently deleted](./tuple-concurrently-deleted.md)
- [tuple already updated by self](./tuple-already-updated-by-self.md)
