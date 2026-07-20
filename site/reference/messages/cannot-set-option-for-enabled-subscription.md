---
message: "cannot set option \"%s\" for enabled subscription"
slug: cannot-set-option-for-enabled-subscription
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:1471"
reproduced: false
---

# `cannot set option "%s" for enabled subscription`

## What it means

An `ALTER SUBSCRIPTION ... SET (...)` tried to change an option that cannot be modified while the subscription is enabled. The named option is only settable on a disabled subscription. The placeholder is the option name.

## When it happens

It occurs when you set an option such as `two_phase` or another start-time option on a subscription that is currently enabled.

## How to fix

Disable the subscription, change the option, then re-enable it. Options that affect how replication starts can only be changed while the subscription is not running.

## Example

*Illustrative* — setting an option on an enabled subscription.

```text
ERROR:  cannot set option "two_phase" for enabled subscription
```

## Related

- [cannot set for enabled subscription](./cannot-set-for-enabled-subscription.md)
- [cannot set option for a subscription that does not have a slot name](./cannot-set-option-for-a-subscription-that-does-not-have-a-slot-name.md)
