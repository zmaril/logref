---
message: "cannot enable retain_dead_tuples if the publisher is running a version earlier than PostgreSQL 19"
slug: cannot-enable-retain-dead-tuples-if-the-publisher-is-running-a-version-earlier
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3305"
reproduced: false
---

# `cannot enable retain_dead_tuples if the publisher is running a version earlier than PostgreSQL 19`

## What it means

An `ALTER SUBSCRIPTION ... SET (retain_dead_tuples = true)` was blocked because the publisher runs a Postgres version older than the one that supports the feature. The publisher must be new enough to participate in dead-tuple retention for conflict detection.

## When it happens

It occurs when enabling `retain_dead_tuples` against a publisher whose server version predates the required release.

## How to fix

Upgrade the publisher to the required version or newer before enabling `retain_dead_tuples`, or leave the option off while the publisher runs an older release.

## Example

*Illustrative* — retain_dead_tuples with an old publisher.

```text
ERROR:  cannot enable retain_dead_tuples if the publisher is running a version earlier than PostgreSQL 19
```

## Related

- [cannot enable retain_dead_tuples if the publisher is in recovery](./cannot-enable-retain-dead-tuples-if-the-publisher-is-in-recovery.md)
- [cannot disable two_phase when prepared transactions exist](./cannot-disable-two-phase-when-prepared-transactions-exist.md)
