---
message: "lost connection to the logical replication parallel apply worker"
slug: lost-connection-to-the-logical-replication-parallel-apply-worker
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/applyparallelworker.c:1144"
  - "postgres/src/backend/replication/logical/applyparallelworker.c:1317"
reproduced: false
---

# `lost connection to the logical replication parallel apply worker`

## What it means

The logical replication leader apply process lost its communication channel to a parallel apply worker. The worker exited or its shared-memory queue became unusable, so the leader cannot continue applying in parallel.

## When it happens

It arises on a subscriber using parallel apply (`streaming = parallel`) when a parallel apply worker crashes, is terminated, or hits an error that ends it, breaking the leader/worker link.

## How to fix

Check the subscriber log for the worker's own error, which explains why it exited (an apply conflict, a constraint violation, or a resource limit). Resolve that cause. As a mitigation you can switch the subscription to non-parallel streaming (`ALTER SUBSCRIPTION s SET (streaming = on)`), or raise worker limits if the workers were starved.

## Example

*Illustrative* — a parallel apply worker went away.

```text
ERROR:  lost connection to the logical replication parallel apply worker
```

## Related

- [is not allowed for disabled subscriptions](./is-not-allowed-for-disabled-subscriptions.md)
- [invalid message received from worker](./invalid-message-received-from-worker.md)
