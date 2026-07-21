---
message: "could not find free replication state slot for replication origin with ID %d"
slug: could-not-find-free-replication-state-slot-for-replication-origin-with-id
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIGURATION_LIMIT_EXCEEDED
    code: "53400"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:996"
  - "postgres/src/backend/replication/logical/origin.c:1256"
reproduced: false
---

# `could not find free replication state slot for replication origin with ID %d`

## What it means

The replication-origin subsystem ran out of in-memory state slots when a new origin tried to become active. The placeholder is the origin ID. The number of concurrently active replication origins is bounded by `max_replication_slots`, and that limit was reached.

## When it happens

Running more logical-replication subscriptions or replication origins than the configured `max_replication_slots` permits, so a new origin cannot acquire a tracking slot.

## How to fix

Raise `max_replication_slots` to accommodate the number of active origins (this requires a restart), or reduce the number of concurrent subscriptions/origins. Account for both physical and logical needs when sizing the parameter.

## Example

*Illustrative* — running out of replication-origin slots.

```text
ERROR:  could not find free replication state slot for replication origin with ID 9
```

## Related

- [could not drop replication slot on publisher](./could-not-drop-replication-slot-on-publisher.md)
- [cannot perform logical decoding without an acquired slot](./cannot-perform-logical-decoding-without-an-acquired-slot.md)
