---
message: "could not drop replication slot \"%s\" on publisher: %s"
slug: could-not-drop-replication-slot-on-publisher
passthrough: false
api: [ereport]
level: [ERROR, LOG]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:2838"
  - "postgres/src/backend/commands/subscriptioncmds.c:2845"
reproduced: false
---

# `could not drop replication slot "%s" on publisher: %s`

## What it means

A subscriber tried to drop its replication slot on the publisher and the request failed. The placeholders are the slot name and the underlying reason. The publisher rejected or could not complete the drop, or the connection failed.

## When it happens

Dropping or altering a subscription (which removes the remote slot) when the publisher is unreachable, the slot is still active, the credentials lack privilege, or the slot no longer exists.

## How to fix

Check the detail for the specific cause. Ensure the publisher is reachable and the subscription's connection has rights to drop the slot, and that the slot is not in use. If the slot is already gone, use `ALTER SUBSCRIPTION ... SET (slot_name = NONE)` before dropping, then remove the orphaned slot on the publisher manually if needed.

## Example

*Illustrative* — a subscriber unable to drop its slot.

```text
ERROR:  could not drop replication slot "sub1" on publisher: ERROR:  replication slot "sub1" is active
```

## Related

- [could not fetch table info for table from publisher](./could-not-fetch-table-info-for-table-from-publisher.md)
- [could not find free replication state slot for replication origin with id](./could-not-find-free-replication-state-slot-for-replication-origin-with-id.md)
