---
message: "API violation: Only one IO can be handed out"
slug: api-violation-only-one-io-can-be-handed-out
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/aio/aio.c:199"
reproduced: false
---

# `API violation: Only one IO can be handed out`

## What it means

The asynchronous I/O subsystem was asked to hand out a second in-progress I/O handle while one was already outstanding, violating its contract that only one may be held at a time — an internal guard.

## When it happens

It is raised when AIO-using code requests another I/O before releasing the previous one, normally only reachable through a bug in I/O-issuing code.

## How to fix

This is an internal invariant aimed at code that drives asynchronous I/O, not a user SQL condition. If a specific extension provokes it, report it to that extension. Capture the log around the error for a bug report; there is no SQL-level workaround.

## Example

*Illustrative* — a second concurrent AIO handout.

```text
ERROR:  API violation: Only one IO can be handed out
```

## Related

- [aio requires a normal PGPROC](./aio-requires-a-normal-pgproc.md)
- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
