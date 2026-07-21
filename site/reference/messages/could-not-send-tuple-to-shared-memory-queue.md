---
message: "could not send tuple to shared-memory queue"
slug: could-not-send-tuple-to-shared-memory-queue
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/executor/tqueue.c:72"
reproduced: false
---

# `could not send tuple to shared-memory queue`

## What it means

A parallel worker could not send a result tuple to the shared-memory queue that carries rows back to the leader. The server flags this as the queue not being ready. This queue joins parallel workers to the gathering node in the leader.

## When it happens

It fires during parallel query execution when a worker's write to the tuple queue fails, usually because the leader detached — the query was cancelled or the leader hit an error and tore the queue down.

## How to fix

This is normally a follow-on from the query ending on the leader's side; look for the real error in the log. If a specific query trips it repeatedly, disabling parallelism for it with `SET max_parallel_workers_per_gather = 0` sidesteps the tuple queue. Investigate the leader-side failure for the actual cause.

## Example

*Illustrative* — the tuple queue was gone.

```text
ERROR:  could not send tuple to shared-memory queue
```

## Related

- [could not send data to shared-memory queue](./could-not-send-data-to-shared-memory-queue.md)
- [could not seek to block in shared tuplestore temporary file](./could-not-seek-to-block-in-shared-tuplestore-temporary-file.md)
