---
message: "trying to store an on-disk heap tuple into wrong type of slot"
slug: trying-to-store-an-on-disk-heap-tuple-into-wrong-type-of-slot
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execTuples.c:1677"
  - "postgres/src/backend/executor/execTuples.c:1703"
reproduced: false
---

# `trying to store an on-disk heap tuple into wrong type of slot`

## What it means

Internal executor error. A physical (on-disk) heap tuple was placed into a tuple-table slot that is not of the heap type, so the slot cannot represent it. Slots are typed by the kind of tuple they hold.

## When it happens

It fires from executor slot handling when a heap tuple is routed to a virtual or minimal slot that does not match. Ordinary queries do not produce it; it points to a mismatch in code, often a custom scan or access method.

## How to fix

This is an internal consistency guard. If a real operation triggers it, capture the statement and any custom access method/table-AM or extension involved and report it as a reproducible bug.

## Example

*Illustrative* — a heap tuple stored in a wrong-type slot.

```text
ERROR:  trying to store an on-disk heap tuple into wrong type of slot
```

## Related

- [tableoid is NULL](./tableoid-is-null.md)
- [record type has not been registered](./record-type-has-not-been-registered.md)
