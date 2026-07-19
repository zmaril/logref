---
message: "doubly linked list head address is NULL"
slug: doubly-linked-list-head-address-is-null
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/lib/ilist.c:82"
reproduced: false
---

# `doubly linked list head address is NULL`

## What it means

An internal data-structure guard. Code accessed a doubly linked list whose head pointer was null, which a properly initialized list never has. This is a "can't happen" consistency check.

## When it happens

It fires from the internal `ilist` routines when a list operation is attempted on an uninitialized or corrupted list head, pointing at an internal bug or memory corruption.

## How to fix

This is not a user-facing condition. It indicates memory corruption or a software defect. Capture the log and server version, note any accompanying crash, and report a reproducible case to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  doubly linked list head address is NULL
```

## Related

- [double linked list member check failure](./double-linked-list-member-check-failure.md)
- [did not find '}' at end of input node](./did-not-find-at-end-of-input-node.md)
