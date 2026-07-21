---
message: "free page manager btree is corrupt"
slug: free-page-manager-btree-is-corrupt
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/mmgr/freepage.c:1534"
  - "postgres/src/backend/utils/mmgr/freepage.c:1689"
reproduced: false
---

# `free page manager btree is corrupt`

## What it means

Internal error. The free-page manager's internal btree, used to track free pages in dynamic shared memory, failed its consistency check. It is a memory-management guard, not a user condition.

## When it happens

It fires when the DSA free-page bookkeeping is inconsistent, which usually reflects memory corruption from a bug in core code or an extension. It does not come from SQL or data.

## How to fix

This points at shared-memory corruption. If extensions are loaded, suspect them. Capture the backtrace and a reproduction and report it as a bug.

## Example

*Illustrative* — the free-page manager btree failed its check.

```text
FATAL:  free page manager btree is corrupt
```

## Related

- [doubly linked list is corrupted](./doubly-linked-list-is-corrupted.md)
- [detected realloc of freed chunk in](./detected-realloc-of-freed-chunk-in.md)
