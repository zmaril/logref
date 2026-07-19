---
message: "encountered tuple with HEAP_MOVED considered in-progress"
slug: encountered-tuple-with-heap-moved-considered-in-progress
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam_visibility.c:246"
reproduced: false
---

# `encountered tuple with HEAP_MOVED considered in-progress`

## What it means

An internal visibility guard. The heap saw a tuple flagged with the obsolete `HEAP_MOVED` bits from pre-9.0 `VACUUM FULL` while evaluating in-progress visibility. Modern versions no longer set these bits, so one now signals very old data or corruption.

## When it happens

It fires during tuple-visibility checks when a heap tuple still carries the legacy `HEAP_MOVED` bits, usually in a long-lived cluster upgraded across many major versions.

## How to fix

This is not an ordinary query error. Rewrite the affected table (`VACUUM FULL` or `CLUSTER`) to clear the legacy bits. If other corruption signs appear, check storage. Capture the case if it persists after a rewrite.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  encountered tuple with HEAP_MOVED considered in-progress
```

## Related

- [encountered tuple with HEAP_MOVED considered current](./encountered-tuple-with-heap-moved-considered-current.md)
- [end of tuple reached without looking at all its data](./end-of-tuple-reached-without-looking-at-all-its-data.md)
