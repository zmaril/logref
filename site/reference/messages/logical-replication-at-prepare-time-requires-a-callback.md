---
message: "logical replication at prepare time requires a %s callback"
slug: logical-replication-at-prepare-time-requires-a-callback
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:929"
  - "postgres/src/backend/replication/logical/logical.c:974"
  - "postgres/src/backend/replication/logical/logical.c:1019"
  - "postgres/src/backend/replication/logical/logical.c:1065"
reproduced: false
---

# `logical replication at prepare time requires a %s callback`

## What it means

A logical decoding output plugin was asked to stream two-phase-commit activity (the PREPARE of a prepared transaction) but did not supply the callback needed to do so. The placeholder names the missing callback. Two-phase decoding is optional, and a plugin that opts into it must implement every required hook.

## When it happens

Starting a logical replication slot or subscription with two-phase commit enabled against an output plugin (or plugin version) that does not implement the prepare/commit-prepared/rollback-prepared callbacks.

## How to fix

Either disable two-phase decoding for the slot/subscription (`CREATE SUBSCRIPTION ... WITH (two_phase = false)`), or use an output plugin build that implements the two-phase callbacks. For the built-in `pgoutput`, ensure both publisher and subscriber are on a version that supports two-phase streaming.

## Example

*Illustrative* — a plugin lacking the two-phase callbacks.

```text
ERROR:  logical replication at prepare time requires a begin_prepare callback
```

## Related

- [could not import the requested snapshot](./could-not-import-the-requested-snapshot.md)
- [publication does not exist](./publication-does-not-exist.md)
