---
message: "could not find custom name for wait event information %u"
slug: could-not-find-custom-name-for-wait-event-information
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/activity/wait_event.c:263"
reproduced: false
---

# `could not find custom name for wait event information %u`

## What it means

The server looked up the display name for a custom wait event by its numeric ID and found none registered. The `%u` is the ID. This is an internal guard in the wait-event machinery.

## When it happens

It fires when reporting wait events (for example in `pg_stat_activity`) and a custom wait event's registered name is missing. It is tied to extensions that register custom wait events.

## How to fix

This is an internal error usually caused by an extension that reports a custom wait event without registering its name, or after being unloaded. Check which extension registers custom wait events and confirm it is loaded correctly. Report a reproducible case to its authors if it recurs.

## Example

*Illustrative* — a custom wait event with no registered name.

```text
ERROR:  could not find custom name for wait event information 42
```

## Related

- [could not find enum option for](./could-not-find-enum-option-for.md)
- [could not find null terminator in GUC state](./could-not-find-null-terminator-in-guc-state.md)
