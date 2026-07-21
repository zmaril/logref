---
message: "ALTER SUBSCRIPTION with refresh and copy_data is not allowed when two_phase is enabled"
slug: alter-subscription-with-refresh-and-copy-data-is-not-allowed-when-two-phase-is
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:2176"
  - "postgres/src/backend/commands/subscriptioncmds.c:2227"
reproduced: false
---

# `ALTER SUBSCRIPTION with refresh and copy_data is not allowed when two_phase is enabled`

## What it means

An `ALTER SUBSCRIPTION` combined a refresh that copies existing data with a subscription that has two-phase commit enabled. That combination is not allowed, because copying initial data cannot be reconciled safely with in-progress two-phase decoding.

## When it happens

Running `ALTER SUBSCRIPTION ... REFRESH PUBLICATION WITH (copy_data = true)` on a subscription created with `two_phase = true`.

## How to fix

Refresh without copying data (`WITH (copy_data = false)`) if the two-phase setting must stay, and load any missing initial data by another route. If you need the copy, the subscription's two-phase mode has to be turned off first; recreate the subscription without two-phase commit where a full initial copy is required.

## Example

*Illustrative* — refresh-with-copy on a two-phase subscription.

```sql
ALTER SUBSCRIPTION s REFRESH PUBLICATION WITH (copy_data = true);  -- not allowed with two_phase
```

## Related

- [alter subscription with refresh is not allowed for disabled subscriptions](./alter-subscription-with-refresh-is-not-allowed-for-disabled-subscriptions.md)
- [subscription does not exist](./subscription-does-not-exist.md)
