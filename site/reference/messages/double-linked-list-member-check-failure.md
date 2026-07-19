---
message: "double linked list member check failure"
slug: double-linked-list-member-check-failure
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/lib/ilist.c:70"
reproduced: false
---

# `double linked list member check failure`

## What it means

An internal data-structure guard. A member of a doubly linked list failed its consistency check — its forward and backward links did not agree. This is a "can't happen" check on in-memory structures.

## When it happens

It fires from the internal `ilist` routines when list-integrity assertions fail, which points at memory corruption or an internal bug rather than anything a query controls.

## How to fix

This is not a user-facing condition. It suggests memory corruption or a software defect. Note whether it correlates with a crash or with faulty hardware; capture the log and server version and report a reproducible case to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  double linked list member check failure
```

## Related

- [doubly linked list head address is NULL](./doubly-linked-list-head-address-is-null.md)
- [did not find '}' at end of input node](./did-not-find-at-end-of-input-node.md)
