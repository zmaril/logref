---
message: "%s is not allowed for disabled subscriptions"
slug: is-not-allowed-for-disabled-subscriptions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:2251"
  - "postgres/src/backend/commands/subscriptioncmds.c:2289"
reproduced: false
---

# `%s is not allowed for disabled subscriptions`

## What it means

A subscription operation cannot be performed while the subscription is disabled. The placeholder names the operation. Some actions require an enabled subscription to take effect.

## When it happens

It arises from `ALTER SUBSCRIPTION` actions — such as refreshing publication or certain option changes — issued against a subscription that is currently disabled.

## How to fix

Enable the subscription first with `ALTER SUBSCRIPTION name ENABLE`, then perform the action, or choose an action that is allowed while disabled. Review which subscription operations require the subscription to be running.

## Example

*Illustrative* — refreshing a disabled subscription.

```sql
ALTER SUBSCRIPTION s REFRESH PUBLICATION;  -- not allowed while disabled
```

## Related

- [lost connection to the logical replication parallel apply worker](./lost-connection-to-the-logical-replication-parallel-apply-worker.md)
- [may only be specified with --create-slot](./may-only-be-specified-with-create-slot.md)
