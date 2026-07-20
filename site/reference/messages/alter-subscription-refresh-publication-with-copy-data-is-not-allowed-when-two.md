---
message: "ALTER SUBSCRIPTION ... REFRESH PUBLICATION with copy_data is not allowed when two_phase is enabled"
slug: alter-subscription-refresh-publication-with-copy-data-is-not-allowed-when-two
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:2274"
reproduced: false
---

# `ALTER SUBSCRIPTION ... REFRESH PUBLICATION with copy_data is not allowed when two_phase is enabled`

## What it means

An `ALTER SUBSCRIPTION ... REFRESH PUBLICATION` requested `copy_data = true`, but the subscription uses two-phase commit, and copying initial data is not allowed while two-phase is enabled.

## When it happens

It occurs when refreshing a subscription's publication with data copy on a subscription created with `two_phase = on`.

## How to fix

Refresh with `copy_data = false`, or temporarily disable two-phase on the subscription, refresh with copy, and re-enable it. When two-phase commit is on, the initial-data copy path for newly added tables is restricted; seed those tables another way if you need their existing rows.

## Example

*Illustrative* — refreshing with copy_data under two_phase.

```sql
ALTER SUBSCRIPTION s REFRESH PUBLICATION WITH (copy_data = true);  -- two_phase is on
```

## Related

- [subscription requested copy_data with origin = NONE](./subscription-requested-copy-data-with-origin-none-but-might-copy-data-that-had.md)
- [apply worker for subscription could not connect to the publisher](./apply-worker-for-subscription-could-not-connect-to-the-publisher.md)
