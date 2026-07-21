---
message: "cannot remove postmaster death event"
slug: cannot-remove-postmaster-death-event
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:680"
reproduced: false
---

# `cannot remove postmaster death event`

## What it means

An internal guard in the wait-event-set code fired: code tried to remove the postmaster-death event from a wait event set. That event is mandatory so backends notice when the postmaster exits, and it may not be removed.

## When it happens

It is reached when a caller attempts to delete the postmaster-death entry from a `WaitEventSet`. It reflects a coding issue in the caller rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or background-worker code managing the wait event set and report it, since the postmaster-death event must remain in place.

## Example

*Illustrative* — removing the postmaster-death event.

```text
ERROR:  cannot remove postmaster death event
```

## Related

- [cannot modify latch event](./cannot-modify-latch-event.md)
- [cannot register background worker after shmem init](./cannot-register-background-worker-after-shmem-init.md)
