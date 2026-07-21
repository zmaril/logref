---
message: "callback %d/%s does not have report callback"
slug: callback-does-not-have-report-callback
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/aio/aio_callback.c:182"
reproduced: false
---

# `callback %d/%s does not have report callback`

## What it means

Internal code was asked to run a reporting action for a registered callback that did not supply one. The placeholders identify the callback. It is an internal consistency check.

## When it happens

It is a can't-happen guard in callback bookkeeping and does not arise from ordinary SQL.

## How to fix

There is no user action. If it appears, note any extensions that register callbacks with the affected subsystem and report it as a possible bug with the server version.

## Example

*Illustrative* — the missing-report guard.

```text
ERROR:  callback 1/foo does not have report callback
```

## Related

- [callback does not have a completion callback](./callback-does-not-have-a-completion-callback.md)
- [callback is out of range](./callback-is-out-of-range.md)
