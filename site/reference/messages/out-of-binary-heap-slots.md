---
message: "out of binary heap slots"
slug: out-of-binary-heap-slots
passthrough: false
api: [elog, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/common/binaryheap.c:119"
  - "postgres/src/common/binaryheap.c:121"
  - "postgres/src/common/binaryheap.c:157"
  - "postgres/src/common/binaryheap.c:159"
reproduced: false
---

# `out of binary heap slots`

## What it means

Internal error. A fixed-capacity binary heap (a priority-queue data structure used in several server and tool algorithms) was asked to hold more elements than it was sized for. The heap is allocated with a known maximum, and code that inserts into it is expected never to exceed that size.

## When it happens

It should not occur through ordinary use. Reaching it indicates a sizing bug in whatever code owns the heap — a miscount of the elements to be inserted — rather than anything a user controls.

## How to fix

Treat it as an internal bug. Note the operation in progress when it fired (it appears in a range of server and utility code paths) and report it with a reproducer. There is no configuration knob for the heap size.

## Example

*Illustrative* — emitted internally by a binary-heap consumer.

```text
ERROR:  out of binary heap slots
```

## Related

- [out of memory](./out-of-memory-0fea34.md)
- [could not find pathkey item to sort](./could-not-find-pathkey-item-to-sort.md)
