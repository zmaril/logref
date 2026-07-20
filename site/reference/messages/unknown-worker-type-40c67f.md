---
message: "Unknown worker type"
slug: unknown-worker-type-40c67f
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/syncutils.c:185"
  - "postgres/src/backend/replication/logical/worker.c:719"
reproduced: false
---

# `Unknown worker type`

## What it means

Internal error. A worker-management path met a worker-type value it does not recognize (a capitalized variant of the same guard, from a different call site).

## When it happens

It fires where a worker's type is classified and the value is outside the known set. Normal operation does not produce it.

## How to fix

This is an internal guard. Capture the surrounding log and report it as a reproducible bug if it appears without a custom worker extension in play.

## Example

*Illustrative* — an unrecognized worker type.

```text
ERROR:  Unknown worker type
```

## Related

- [unknown worker type](./unknown-worker-type-319e82.md)
- [worker process failed: exit code %d](./worker-process-failed-exit-code.md)
