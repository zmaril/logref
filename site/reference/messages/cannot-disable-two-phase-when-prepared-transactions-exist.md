---
message: "cannot disable \"two_phase\" when prepared transactions exist"
slug: cannot-disable-two-phase-when-prepared-transactions-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:1852"
reproduced: false
---

# `cannot disable "two_phase" when prepared transactions exist`

## What it means

An `ALTER SUBSCRIPTION ... SET (two_phase = false)` was blocked because the subscription still has prepared (two-phase) transactions outstanding. Turning off two-phase support while such transactions are pending would strand them.

## When it happens

It occurs when disabling `two_phase` on a subscription that has replicated but not yet resolved prepared transactions.

## How to fix

Resolve the outstanding prepared transactions — commit or roll them back — before disabling `two_phase`. Once none remain, the option can be turned off.

## Example

*Illustrative* — disabling two_phase with prepared transactions.

```text
ERROR:  cannot disable "two_phase" when prepared transactions exist
```

## Related

- [cannot enable subscription that does not have a slot name](./cannot-enable-subscription-that-does-not-have-a-slot-name.md)
- [cannot drop all the publications from a subscription](./cannot-drop-all-the-publications-from-a-subscription.md)
