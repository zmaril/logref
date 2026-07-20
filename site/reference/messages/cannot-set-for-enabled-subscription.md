---
message: "cannot set %s for enabled subscription"
slug: cannot-set-for-enabled-subscription
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:1737"
reproduced: false
---

# `cannot set %s for enabled subscription`

## What it means

An `ALTER SUBSCRIPTION ... SET` tried to change an option that cannot be changed while the subscription is enabled. The named option can only be set on a disabled subscription. The placeholder is the option name.

## When it happens

It occurs when you alter an option such as `slot_name` or another connection-related setting on a subscription that is currently enabled.

## How to fix

Disable the subscription with `ALTER SUBSCRIPTION ... DISABLE`, change the option, then re-enable it. Some options can only be adjusted while the subscription is not running.

## Example

*Illustrative* — setting an option on an enabled subscription.

```text
ERROR:  cannot set slot_name for enabled subscription
```

## Related

- [cannot set option for enabled subscription](./cannot-set-option-for-enabled-subscription.md)
- [cannot set option for a subscription that does not have a slot name](./cannot-set-option-for-a-subscription-that-does-not-have-a-slot-name.md)
