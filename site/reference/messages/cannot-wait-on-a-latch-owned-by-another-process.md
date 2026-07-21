---
message: "cannot wait on a latch owned by another process"
slug: cannot-wait-on-a-latch-owned-by-another-process
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:587"
  - "postgres/src/backend/storage/ipc/waiteventset.c:704"
reproduced: false
---

# `cannot wait on a latch owned by another process`

## What it means

Internal error. A backend tried to wait on a latch (an inter-process wakeup primitive) that belongs to a different process. A process may only wait on its own latch, so this cross-process wait is a bookkeeping violation.

## When it happens

It should not occur through ordinary use. Reaching it points to an internal inconsistency in wait-event or IPC setup, not to anything in your query or configuration.

## How to fix

Treat it as an internal bug. Capture the server log around the event and the workload that provoked it and report it. There is no user-side change expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally by the wait-event machinery.

```text
ERROR:  cannot wait on a latch owned by another process
```

## Related

- [cannot wait without a PGPROC structure](./cannot-wait-without-a-pgproc-structure.md)
- [could not duplicate handle for](./could-not-duplicate-handle-for.md)
