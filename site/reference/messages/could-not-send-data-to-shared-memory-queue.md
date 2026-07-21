---
message: "could not send data to shared-memory queue"
slug: could-not-send-data-to-shared-memory-queue
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/replication/logical/applyparallelworker.c:1197"
reproduced: false
---

# `could not send data to shared-memory queue`

## What it means

A parallel apply worker for logical replication could not place data into the shared-memory queue it uses to communicate with the leader. The server flags this as the queue not being in a usable state.

## When it happens

It fires during parallel-apply logical replication when the queue between the leader and a worker cannot accept a message, typically because the peer detached — the worker exited or the leader tore the queue down.

## How to fix

Look for the accompanying worker or leader error in the log; this message is usually a follow-on from the peer going away. If parallel apply is unstable in your environment, you can fall back by setting the subscription's `streaming` option to `on` instead of `parallel`. Address the underlying worker failure for a real fix.

## Example

*Illustrative* — the shared-memory queue was gone.

```text
ERROR:  could not send data to shared-memory queue
```

## Related

- [could not send tuple to shared-memory queue](./could-not-send-tuple-to-shared-memory-queue.md)
- [could not start initial contents copy for table](./could-not-start-initial-contents-copy-for-table.md)
