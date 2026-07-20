---
message: "callback %d is out of range"
slug: callback-is-out-of-range
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/aio/aio_callback.c:93"
reproduced: false
---

# `callback %d is out of range`

## What it means

Internal code referenced a callback by an index outside the range of registered callbacks. The placeholder is the index. It is an internal bounds check.

## When it happens

It is a can't-happen guard in callback bookkeeping and does not arise from ordinary SQL.

## How to fix

There is no user action. If it appears, note any extensions that register callbacks and report it as a possible bug with the server version.

## Example

*Illustrative* — the bounds guard.

```text
ERROR:  callback 5 is out of range
```

## Related

- [callback does not have a completion callback](./callback-does-not-have-a-completion-callback.md)
- [cache entry already complete](./cache-entry-already-complete.md)
