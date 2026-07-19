---
message: "attempted to kill a non-speculative tuple"
slug: attempted-to-kill-a-non-speculative-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6188"
reproduced: false
---

# `attempted to kill a non-speculative tuple`

## What it means

The speculative-insertion machinery (used by `INSERT ... ON CONFLICT`) tried to remove a tuple that was not a speculative one, which should never happen — an internal consistency guard.

## When it happens

It is raised during `INSERT ... ON CONFLICT` conflict handling if the tuple slated for speculative cleanup is not marked speculative, normally only through a bug.

## How to fix

This is an internal error rather than a user SQL fault. If a particular workload reproduces it, capture the statement and log and report it. There is no reliable user-level workaround; if it coincides with corruption symptoms, check the table and its indexes.

## Example

*Illustrative* — speculative cleanup hitting a non-speculative tuple.

```text
ERROR:  attempted to kill a non-speculative tuple
```

## Related

- [attempted to kill a tuple inserted by another transaction](./attempted-to-kill-a-tuple-inserted-by-another-transaction.md)
- [attempted to delete invisible tuple](./attempted-to-delete-invisible-tuple.md)
