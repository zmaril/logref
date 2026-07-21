---
message: "could not find free replication state, increase \"max_active_replication_origins\""
slug: could-not-find-free-replication-state-increase-max-active-replication-origins
passthrough: false
api: [ereport]
level: [PANIC]
sqlstate:
  - symbol: ERRCODE_CONFIGURATION_LIMIT_EXCEEDED
    code: "53400"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:836"
reproduced: false
---

# `could not find free replication state, increase "max_active_replication_origins"`

## What it means

A backend needed an in-memory replication-state slot to track progress for a replication origin and none was free. The message names the setting that bounds these slots. Without a slot the origin cannot be made active.

## When it happens

It happens when more replication origins become active at once than `max_active_replication_origins` allows — for example many subscriptions applying changes concurrently.

## How to fix

Raise `max_active_replication_origins` and restart the server. Set it to at least the number of subscriptions or active origins the cluster needs to run in parallel.

## Example

*Illustrative* — active-origin slots exhausted.

```text
PANIC:  could not find free replication state, increase "max_active_replication_origins"
```

## Related

- [could not find free replication origin ID](./could-not-find-free-replication-origin-id.md)
- [could not drop replication origin with ID, in use by PID](./could-not-drop-replication-origin-with-id-in-use-by-pid.md)
