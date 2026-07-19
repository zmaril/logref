---
message: "cannot add new values to integer set while iteration is in progress"
slug: cannot-add-new-values-to-integer-set-while-iteration-is-in-progress
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/lib/integerset.c:372"
reproduced: false
---

# `cannot add new values to integer set while iteration is in progress`

## What it means

Internal code tried to add values to an integer-set structure while an iteration over it was still open. The structure does not allow modification during iteration. It is an internal consistency check.

## When it happens

It is a can't-happen guard in the integer-set data structure used by some maintenance and index-build paths, and does not arise from ordinary SQL.

## How to fix

There is no user action. If it appears, capture the operation that was running — often an index build or vacuum — and any extensions involved, and report it as a possible bug.

## Example

*Illustrative* — modifying an integer set mid-iteration.

```text
ERROR:  cannot add new values to integer set while iteration is in progress
```

## Related

- [cannot add value to integer set out of order](./cannot-add-value-to-integer-set-out-of-order.md)
- [can't attach the same segment more than once](./can-t-attach-the-same-segment-more-than-once.md)
