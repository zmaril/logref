---
message: "unexpected apply action: %d"
slug: unexpected-apply-action
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/worker.c:865"
  - "postgres/src/backend/replication/logical/worker.c:1653"
  - "postgres/src/backend/replication/logical/worker.c:1865"
  - "postgres/src/backend/replication/logical/worker.c:1981"
  - "postgres/src/backend/replication/logical/worker.c:2234"
  - "postgres/src/backend/replication/logical/worker.c:2501"
reproduced: false
---

# `unexpected apply action: %d`

## What it means

Internal error. The logical replication apply worker runs a small state machine over the streamed protocol messages, and it reached an action code it has no handler for. The placeholder is the numeric action. It is a consistency check on the worker's own protocol state.

## When it happens

It should not occur between compatible publisher and subscriber. Reaching it suggests a protocol-version mismatch, a bug in the apply worker, or corrupted replication state.

## How to fix

Treat it as an internal replication bug. Check that publisher and subscriber are compatible Postgres versions. If reproducible, capture the subscription setup and server logs from both ends and report it.

## Example

*Illustrative* — emitted internally by the apply worker.

```text
ERROR:  unexpected apply action: 5
```

## Related

- [unexpected partition strategy](./unexpected-partition-strategy.md)
- [logical streaming requires a callback](./logical-streaming-requires-a-callback.md)
