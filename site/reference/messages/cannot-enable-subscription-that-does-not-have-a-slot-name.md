---
message: "cannot enable subscription that does not have a slot name"
slug: cannot-enable-subscription-that-does-not-have-a-slot-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:2023"
reproduced: false
---

# `cannot enable subscription that does not have a slot name`

## What it means

An `ALTER SUBSCRIPTION ... ENABLE` targeted a subscription that has no replication slot name configured. A subscription needs a slot to stream changes, so one with `slot_name = NONE` cannot be enabled.

## When it happens

It occurs when enabling a subscription that was created or altered with no slot name, often one set up with `create_slot = false` and `slot_name = NONE`.

## How to fix

Set a valid slot name with `ALTER SUBSCRIPTION ... SET (slot_name = '...')`, ensuring the slot exists on the publisher, before enabling. A subscription cannot stream without an associated slot.

## Example

*Illustrative* — enabling a slot-less subscription.

```text
ERROR:  cannot enable subscription that does not have a slot name
```

## Related

- [cannot drop all the publications from a subscription](./cannot-drop-all-the-publications-from-a-subscription.md)
- [cannot enable retain_dead_tuples if the publisher is in recovery](./cannot-enable-retain-dead-tuples-if-the-publisher-is-in-recovery.md)
