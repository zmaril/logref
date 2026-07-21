---
message: "encountered tuple with HEAP_MOVED considered current"
slug: encountered-tuple-with-heap-moved-considered-current
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam_visibility.c:243"
reproduced: false
---

# `encountered tuple with HEAP_MOVED considered current`

## What it means

An internal visibility guard. The heap saw a tuple flagged with the obsolete `HEAP_MOVED_IN`/`HEAP_MOVED_OFF` bits, which pre-9.0 `VACUUM FULL` used and modern versions no longer produce. Encountering one now indicates very old, unconverted data or corruption.

## When it happens

It fires during tuple-visibility checks when a heap tuple carries the legacy `HEAP_MOVED` bits, typically from a cluster pg_upgraded across many major versions without the old rows ever being rewritten.

## How to fix

This is not an ordinary query error. Rewrite the affected table to clear the legacy bits, for example with `VACUUM FULL` or by `CLUSTER`ing the table. If it accompanies other corruption signs, check storage health. Capture the case if it recurs after a rewrite.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  encountered tuple with HEAP_MOVED considered current
```

## Related

- [encountered tuple with HEAP_MOVED considered in-progress](./encountered-tuple-with-heap-moved-considered-in-progress.md)
- [end of tuple reached without looking at all its data](./end-of-tuple-reached-without-looking-at-all-its-data.md)
