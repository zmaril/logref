---
message: "too many LWLocks taken"
slug: too-many-lwlocks-taken
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/lmgr/lwlock.c:1182"
  - "postgres/src/backend/storage/lmgr/lwlock.c:1331"
  - "postgres/src/backend/storage/lmgr/lwlock.c:1395"
reproduced: false
---

# `too many LWLocks taken`

## What it means

Internal error. A backend tried to acquire more lightweight locks at once than the fixed limit allows. Lightweight locks are held briefly and in small numbers by design, and exceeding the per-backend limit indicates code holding too many simultaneously.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency or a bug — possibly in an extension — that acquires lightweight locks without releasing them, rather than to your workload as such.

## How to fix

Treat it as an internal or extension bug. Note any extensions in use, capture the operation that triggered it, and report it. If an extension is implicated, updating or removing it may work around the leak.

## Example

*Illustrative* — exceeding the lightweight-lock limit.

```text
ERROR:  too many LWLocks taken
```

## Related

- [lock table corrupted](./lock-table-corrupted.md)
- [not enough space to serialize guc state](./not-enough-space-to-serialize-guc-state.md)
