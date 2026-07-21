---
message: "MyProcNumber not set"
slug: myprocnumber-not-set
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/procsignal.c:178"
  - "postgres/src/backend/storage/ipc/sinvaladt.c:281"
reproduced: false
---

# `MyProcNumber not set`

## What it means

Internal error. Code referenced `MyProcNumber` — a backend's index into the shared process array — before it was assigned. It is a consistency guard in process/shared-state setup.

## When it happens

It fires when shared-state code runs before the backend has been slotted into the proc array, an ordering that should not happen. Ordinary SQL does not surface it; it points to an internal bug or misuse from an extension's early startup code.

## How to fix

This is a can't-happen guard for normal operation. If an extension runs shared-memory or proc-array code during early startup, review its initialization ordering. Otherwise capture the scenario and report a reproducible case.

## Example

*Illustrative* — proc number used before assignment.

```text
ERROR:  MyProcNumber not set
```

## Related

- [invalid processing mode in background worker](./invalid-processing-mode-in-background-worker.md)
- [invalid message received from worker](./invalid-message-received-from-worker.md)
