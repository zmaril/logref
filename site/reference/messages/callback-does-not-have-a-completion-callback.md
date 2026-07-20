---
message: "callback %d does not have a completion callback"
slug: callback-does-not-have-a-completion-callback
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/aio/aio_callback.c:96"
reproduced: false
---

# `callback %d does not have a completion callback`

## What it means

Internal progress or resource-owner code was asked to run a completion action for a registered callback that never provided one. The placeholder is the callback index. It is an internal consistency check.

## When it happens

It is a can't-happen guard in callback bookkeeping and does not arise from ordinary SQL.

## How to fix

There is no user action. If it appears, note any extensions that register callbacks with the affected subsystem and report it as a possible bug with the server version.

## Example

*Illustrative* — the missing-completion guard.

```text
ERROR:  callback 2 does not have a completion callback
```

## Related

- [callback does not have report callback](./callback-does-not-have-report-callback.md)
- [callback is out of range](./callback-is-out-of-range.md)
