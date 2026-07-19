---
message: "close of %s when %s was expected"
slug: close-of-when-was-expected
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:536"
reproduced: false
---

# `close of %s when %s was expected`

## What it means

An internal guard fired in the COPY or bulk-load state machine: a close named a different relation than the one currently open. The message reports what was closed and what was expected, indicating the calls are out of order.

## When it happens

It is reached from internal copy or load handling. It reflects a coding issue in that path rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any extensions in use, and the server log, then report it. It points to a bug in the copy or load code.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  close of a when b was expected
```

## Related

- [close of before any relation was opened](./close-of-before-any-relation-was-opened.md)
- [cluster does not support lossy index conditions](./cluster-does-not-support-lossy-index-conditions.md)
