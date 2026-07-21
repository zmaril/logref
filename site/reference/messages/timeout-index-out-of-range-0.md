---
message: "timeout index %d out of range 0..%d"
slug: timeout-index-out-of-range-0
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/misc/timeout.c:119"
  - "postgres/src/backend/utils/misc/timeout.c:142"
reproduced: false
---

# `timeout index %d out of range 0..%d`

## What it means

Internal error. A timeout was requested or referenced with an index outside the valid range of registered timeout slots. The placeholders are the index and the upper bound. Postgres manages a fixed set of timeout sources by index.

## When it happens

It fires from the timeout subsystem when code passes a bad timeout id — a programming error in core or an extension that registers/uses timeouts incorrectly.

## How to fix

This is an internal guard. If an extension is involved, its timeout registration is likely at fault; report it there. Capture the log and the extension in use.

## Example

*Illustrative* — a timeout referenced by an out-of-range index.

```text
FATAL:  timeout index 12 out of range 0..11
```

## Related

- [proc header uninitialized](./proc-header-uninitialized.md)
- [sem_trywait failed: %m](./sem-trywait-failed.md)
