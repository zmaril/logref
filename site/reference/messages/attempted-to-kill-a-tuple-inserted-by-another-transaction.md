---
message: "attempted to kill a tuple inserted by another transaction"
slug: attempted-to-kill-a-tuple-inserted-by-another-transaction
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:6186"
reproduced: false
---

# `attempted to kill a tuple inserted by another transaction`

## What it means

The speculative-insertion machinery tried to remove a tuple that belongs to a different transaction, which it must never do, so the operation was stopped — an internal consistency guard.

## When it happens

It is raised during `INSERT ... ON CONFLICT` speculative cleanup if the tuple to be removed was inserted by another transaction, normally only through a bug.

## How to fix

This is an internal error, not a user-fixable query. If a workload reproduces it, capture the statement and log and report it. There is no reliable SQL-level workaround; investigate for corruption if it comes with other integrity symptoms.

## Example

*Illustrative* — speculative cleanup targeting another transaction's tuple.

```text
ERROR:  attempted to kill a tuple inserted by another transaction
```

## Related

- [attempted to kill a non-speculative tuple](./attempted-to-kill-a-non-speculative-tuple.md)
- [attempted to delete invisible tuple](./attempted-to-delete-invisible-tuple.md)
