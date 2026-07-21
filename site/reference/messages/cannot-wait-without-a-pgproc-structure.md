---
message: "cannot wait without a PGPROC structure"
slug: cannot-wait-without-a-pgproc-structure
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/access/transam/xlog.c:1555"
  - "postgres/src/backend/storage/lmgr/lwlock.c:1026"
reproduced: false
---

# `cannot wait without a PGPROC structure`

## What it means

PANIC-level internal error. Code tried to sleep on a lock or latch before (or after) the backend's `PGPROC` shared-memory slot was set up. Without that structure there is no place to register the wait, so the backend cannot safely continue.

## When it happens

It should not occur in normal operation. Reaching it points to an internal ordering fault — a wait attempted outside the window where the backend has a valid `PGPROC` — typically very early in startup or during shutdown.

## How to fix

Treat it as a critical internal fault. The backend PANICs; preserve the server log around the event and report it, noting what the server was doing (startup, shutdown, recovery) when it fired.

## Example

*Illustrative* — emitted internally when no PGPROC is available.

```text
PANIC:  cannot wait without a PGPROC structure
```

## Related

- [cannot wait on a latch owned by another process](./cannot-wait-on-a-latch-owned-by-another-process.md)
- [cannot abort transaction it was already committed](./cannot-abort-transaction-it-was-already-committed.md)
