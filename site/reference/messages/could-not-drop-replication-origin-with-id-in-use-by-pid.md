---
message: "could not drop replication origin with ID %d, in use by PID %d"
slug: could-not-drop-replication-origin-with-id-in-use-by-pid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/replication/logical/origin.c:408"
reproduced: false
---

# `could not drop replication origin with ID %d, in use by PID %d`

## What it means

An attempt to drop a replication origin failed because another backend, identified by PID, is currently using it. The `%d` values are the origin ID and the holding process. A replication origin in active use cannot be removed.

## When it happens

It happens when dropping a replication origin (directly or as part of dropping a subscription) while an apply worker or another session still has that origin acquired.

## How to fix

Stop the process using the origin first. For a subscription, disable it (`ALTER SUBSCRIPTION ... DISABLE`) so its apply worker releases the origin, then retry. The named PID identifies the holder to investigate.

## Example

*Illustrative* — an origin still held by an apply worker.

```text
ERROR:  could not drop replication origin with ID 3, in use by PID 4821
```

## Related

- [could not find free replication origin ID](./could-not-find-free-replication-origin-id.md)
- [could not drop relation mapping for subscription](./could-not-drop-relation-mapping-for-subscription.md)
