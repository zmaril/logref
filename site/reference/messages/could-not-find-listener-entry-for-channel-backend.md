---
message: "could not find listener entry for channel \"%s\" backend %d"
slug: could-not-find-listener-entry-for-channel-backend
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/commands/async.c:1821"
reproduced: false
---

# `could not find listener entry for channel "%s" backend %d`

## What it means

The `LISTEN`/`NOTIFY` machinery could not find the listener entry for a channel and backend it expected to be registered. The `%s` and `%d` give the channel and backend. This is a critical internal invariant.

## When it happens

It fires in the asynchronous-notification subsystem when a backend's registered listener slot is missing. Reaching it signals internal shared-state corruption, so the server escalates to a PANIC.

## How to fix

This is an internal error that stops the server. Capture the log and any core dump. It points at shared-memory corruption or a bug rather than a configuration problem — report a reproducible case with the surrounding log.

## Example

*Illustrative* — a missing listener entry.

```text
PANIC:  could not find listener entry for channel "my_chan" backend 42
```

## Related

- [could not find entry in sinval array](./could-not-find-entry-in-sinval-array.md)
- [could not find just referenced shared stats entry](./could-not-find-just-referenced-shared-stats-entry.md)
