---
message: "ALTER SUBSCRIPTION with refresh is not allowed for disabled subscriptions"
slug: alter-subscription-with-refresh-is-not-allowed-for-disabled-subscriptions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:2166"
  - "postgres/src/backend/commands/subscriptioncmds.c:2213"
reproduced: false
---

# `ALTER SUBSCRIPTION with refresh is not allowed for disabled subscriptions`

## What it means

A refresh was requested on a subscription that is currently disabled. Refreshing a publication needs an active subscription connection to fetch the current set of tables, which a disabled subscription cannot provide.

## When it happens

Running `ALTER SUBSCRIPTION ... REFRESH PUBLICATION` on a subscription that was disabled with `ALTER SUBSCRIPTION ... DISABLE`.

## How to fix

Enable the subscription first (`ALTER SUBSCRIPTION ... ENABLE`), then refresh, or perform the refresh as part of re-enabling it. If you intend to change the table set without connecting, do so with options that do not require a refresh, then enable and refresh when a connection is available.

## Example

*Illustrative* — refreshing a disabled subscription.

```sql
ALTER SUBSCRIPTION s REFRESH PUBLICATION;  -- not allowed while disabled
```

## Related

- [alter subscription with refresh and copy data is not allowed when two phase is](./alter-subscription-with-refresh-and-copy-data-is-not-allowed-when-two-phase-is.md)
- [subscription does not exist](./subscription-does-not-exist.md)
