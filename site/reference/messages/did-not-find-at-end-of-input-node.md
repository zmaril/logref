---
message: "did not find '}' at end of input node"
slug: did-not-find-at-end-of-input-node
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/read.c:341"
reproduced: false
---

# `did not find '}' at end of input node`

## What it means

An internal node-reader guard. PostgreSQL was parsing a serialized plan/parse node and did not find the expected closing brace at the end of a subnode. The stored node representation was malformed. This is a "can't happen" check.

## When it happens

It fires in the internal `nodeRead` routines when reading a node tree — for example from a stored rule, view, or a plan passed between backend processes — that is truncated or corrupted.

## How to fix

This is not a user query error. It points at a corrupted stored node (a damaged rule/view definition) or an internal bug. Investigate catalog integrity; if a specific rule or view triggers it, recreate that object. Capture the case for the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  did not find '}' at end of input node
```

## Related

- [double linked list member check failure](./double-linked-list-member-check-failure.md)
- [doubly linked list head address is NULL](./doubly-linked-list-head-address-is-null.md)
