---
message: "close of %s before any relation was opened"
slug: close-of-before-any-relation-was-opened
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:540"
reproduced: false
---

# `close of %s before any relation was opened`

## What it means

An internal guard fired in the COPY or bulk-load state machine: a close of a relation stream happened before any relation had been opened. The open and close calls must be balanced, so this state should not occur.

## When it happens

It is reached from internal copy or load handling. It reflects a coding issue in that path rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any extensions in use, and the server log, then report it. It points to a bug in the copy or load code.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  close of x before any relation was opened
```

## Related

- [close of when was expected](./close-of-when-was-expected.md)
- [cluster does not support lossy index conditions](./cluster-does-not-support-lossy-index-conditions.md)
