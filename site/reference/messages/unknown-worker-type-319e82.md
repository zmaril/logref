---
message: "unknown worker type"
slug: unknown-worker-type-319e82
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/launcher.c:548"
  - "postgres/src/backend/replication/logical/launcher.c:1704"
reproduced: false
---

# `unknown worker type`

## What it means

Internal error. Code dispatching on a worker classification found a worker-type value outside the set it recognizes.

## When it happens

It fires where the kind of a background or parallel worker is switched on and the value does not match a known case. Normal operation does not reach it.

## How to fix

This is an internal guard. If it appears without an extension registering custom workers, capture the surrounding log and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized worker type.

```text
ERROR:  unknown worker type
```

## Related

- [Unknown worker type](./unknown-worker-type-40c67f.md)
- [worker process failed: exit code %d](./worker-process-failed-exit-code.md)
