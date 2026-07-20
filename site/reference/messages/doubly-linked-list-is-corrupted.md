---
message: "doubly linked list is corrupted"
slug: doubly-linked-list-is-corrupted
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/lib/ilist.c:95"
  - "postgres/src/backend/lib/ilist.c:106"
reproduced: false
---

# `doubly linked list is corrupted`

## What it means

Internal error. An in-memory doubly linked list failed its integrity check — a node's forward and backward links did not agree. It is a data-structure consistency guard, not a user condition.

## When it happens

It fires when list bookkeeping is inconsistent, which usually indicates memory corruption from a bug in core code or a loaded extension. It does not come from SQL or data.

## How to fix

This points at memory corruption. If extensions or custom C code are loaded, suspect them first. Capture the backtrace and a reproduction and report it as a bug.

## Example

*Illustrative* — a linked-list integrity check failed.

```text
ERROR:  doubly linked list is corrupted
```

## Related

- [detected realloc of freed chunk in](./detected-realloc-of-freed-chunk-in.md)
- [free page manager btree is corrupt](./free-page-manager-btree-is-corrupt.md)
