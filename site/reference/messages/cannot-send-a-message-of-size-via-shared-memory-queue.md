---
message: "cannot send a message of size %zu via shared memory queue"
slug: cannot-send-a-message-of-size-via-shared-memory-queue
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/storage/ipc/shm_mq.c:383"
reproduced: false
---

# `cannot send a message of size %zu via shared memory queue`

## What it means

A message was too large to send through a shared-memory message queue. The queue has a fixed capacity, and a single message cannot exceed it. The placeholder is the message size.

## When it happens

It is reached in parallel-query or background-worker communication when a tuple or control message is larger than the shared-memory queue that carries it. It usually points to an internal limit rather than a user action.

## How to fix

There is no direct user setting for the queue size at the moment it fires. If it recurs with a specific workload, capture the query and the feature driving the parallel or worker communication and report it; reducing very wide rows can help avoid oversize messages.

## Example

*Illustrative* — a message larger than the queue.

```text
ERROR:  cannot send a message of size 1073741824 via shared memory queue
```

## Related

- [cannot pin a segment that is already pinned](./cannot-pin-a-segment-that-is-already-pinned.md)
- [cannot request shared memory at this time](./cannot-request-shared-memory-at-this-time.md)
