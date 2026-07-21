---
message: "BeginInternalSubTransaction: unexpected state %s"
slug: begininternalsubtransaction-unexpected-state
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4803"
reproduced: false
---

# `BeginInternalSubTransaction: unexpected state %s`

## What it means

The routine that starts an internal subtransaction found the transaction in a state where a subtransaction cannot begin. The placeholder names the current state. It guards the transaction state machine.

## When it happens

It is an internal guard that can appear when a `PL` function, exception block, or extension tries to open a subtransaction from an invalid point such as an already-aborted transaction.

## How to fix

This usually reflects a bug in extension or procedural code that manages subtransactions. Capture the function or extension driving the subtransaction and the preceding statements, and report it. It is not caused by ordinary SQL.

## Example

*Illustrative* — a subtransaction from a bad state.

```text
FATAL:  BeginInternalSubTransaction: unexpected state STARTED
```

## Related

- [begintransactionblock unexpected state](./begintransactionblock-unexpected-state.md)
- [before_shmem_exit has been called prematurely](./before-shmem-exit-has-been-called-prematurely.md)
