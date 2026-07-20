---
message: "cannot set option \"%s\" for a subscription that does not have a slot name"
slug: cannot-set-option-for-a-subscription-that-does-not-have-a-slot-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:1485"
reproduced: false
---

# `cannot set option "%s" for a subscription that does not have a slot name`

## What it means

An `ALTER SUBSCRIPTION ... SET` tried to change a slot-related option on a subscription whose `slot_name` is `NONE`. Without an associated replication slot, the named option has nothing to apply to. The placeholder is the option name.

## When it happens

It occurs when you set an option such as `failover` or another slot-tied setting on a subscription created with `slot_name = NONE`.

## How to fix

Associate the subscription with a slot first — set a `slot_name` that exists on the publisher — then adjust the slot-related option. Options tied to a slot require one to be present.

## Example

*Illustrative* — a slot option on a slotless subscription.

```text
ERROR:  cannot set option "failover" for a subscription that does not have a slot name
```

## Related

- [cannot set option for enabled subscription](./cannot-set-option-for-enabled-subscription.md)
- [cannot set for enabled subscription](./cannot-set-for-enabled-subscription.md)
