---
message: "aio requires a normal PGPROC"
slug: aio-requires-a-normal-pgproc
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/aio/aio_init.c:247"
reproduced: false
---

# `aio requires a normal PGPROC`

## What it means

The asynchronous I/O subsystem was invoked from a process that does not have a normal `PGPROC` slot, which it requires, so the AIO request could not be issued — an internal guard.

## When it happens

It is raised when asynchronous I/O is reached from an auxiliary or bootstrap process that lacks the standard backend process structure AIO depends on.

## How to fix

This is an internal invariant, not a user-level error. It would normally indicate a bug in a background process or extension issuing I/O in an unsupported context. Capture the surrounding log and report it; there is no SQL workaround.

## Example

*Illustrative* — AIO used without a normal backend process.

```text
ERROR:  aio requires a normal PGPROC
```

## Related

- [API violation: Only one IO can be handed out](./api-violation-only-one-io-can-be-handed-out.md)
- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
