---
message: "cannot enable retain_dead_tuples if the publisher is in recovery"
slug: cannot-enable-retain-dead-tuples-if-the-publisher-is-in-recovery
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3324"
reproduced: false
---

# `cannot enable retain_dead_tuples if the publisher is in recovery`

## What it means

An `ALTER SUBSCRIPTION ... SET (retain_dead_tuples = true)` was blocked because the publisher is currently in recovery — a standby that has not been promoted. Retaining dead tuples for conflict detection requires the publisher to be a normally operating primary.

## When it happens

It occurs when enabling `retain_dead_tuples` on a subscription whose publisher server is still in recovery.

## How to fix

Enable `retain_dead_tuples` once the publisher is out of recovery and operating as a primary. Wait for or promote the publisher before setting the option.

## Example

*Illustrative* — retain_dead_tuples with a recovering publisher.

```text
ERROR:  cannot enable retain_dead_tuples if the publisher is in recovery
```

## Related

- [cannot enable retain_dead_tuples if the publisher is running an earlier version](./cannot-enable-retain-dead-tuples-if-the-publisher-is-running-a-version-earlier.md)
- [cannot enable subscription that does not have a slot name](./cannot-enable-subscription-that-does-not-have-a-slot-name.md)
