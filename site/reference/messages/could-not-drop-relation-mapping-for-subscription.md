---
message: "could not drop relation mapping for subscription \"%s\""
slug: could-not-drop-relation-mapping-for-subscription
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/pg_subscription.c:546"
reproduced: false
---

# `could not drop relation mapping for subscription "%s"`

## What it means

Removing a subscription's stored relation-state mapping failed. A follow-on detail usually explains why. The per-table sync state for the subscription could not be cleared.

## When it happens

It happens during subscription changes (such as `ALTER SUBSCRIPTION ... REFRESH PUBLICATION` or `DROP SUBSCRIPTION`) when the relation-mapping entries cannot be removed in their current state.

## How to fix

Check the accompanying detail for the specific reason. In practice this is tied to a table still mid-sync; wait for the sync to settle or disable the subscription first, then retry the operation.

## Example

*Illustrative* — relation mapping that cannot be dropped.

```text
ERROR:  could not drop relation mapping for subscription "my_sub"
```

## Related

- [could not drop subscription](./could-not-drop-subscription.md)
- [could not enable subscription](./could-not-enable-subscription.md)
