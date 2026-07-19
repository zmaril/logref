---
message: "cannot drop all the publications from a subscription"
slug: cannot-drop-all-the-publications-from-a-subscription
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3676"
reproduced: false
---

# `cannot drop all the publications from a subscription`

## What it means

An `ALTER SUBSCRIPTION ... DROP PUBLICATION` would remove the last publication from the subscription. A subscription must reference at least one publication, so emptying its publication list is not allowed.

## When it happens

It occurs when dropping the only remaining publication, or all publications at once, from a subscription.

## How to fix

Keep at least one publication on the subscription, or drop the subscription entirely with `DROP SUBSCRIPTION` if it is no longer needed. To change publications, add the new one before removing the last old one.

## Example

*Illustrative* — emptying a subscription's publications.

```text
ERROR:  cannot drop all the publications from a subscription
```

## Related

- [cannot disable two_phase when prepared transactions exist](./cannot-disable-two-phase-when-prepared-transactions-exist.md)
- [cannot enable subscription that does not have a slot name](./cannot-enable-subscription-that-does-not-have-a-slot-name.md)
