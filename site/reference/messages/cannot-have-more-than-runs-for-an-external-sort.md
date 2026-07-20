---
message: "cannot have more than %d runs for an external sort"
slug: cannot-have-more-than-runs-for-an-external-sort
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/utils/sort/tuplesort.c:2235"
reproduced: false
---

# `cannot have more than %d runs for an external sort`

## What it means

An external (on-disk) sort produced more sorted runs than the merge logic can combine. When a sort spills to disk it writes runs and later merges them, and the number of runs exceeded the internal limit. The placeholder is the maximum run count.

## When it happens

It occurs on an extremely large sort with a small `work_mem`, which forces many tiny runs, or on a data set so large that the run count reaches the cap.

## How to fix

Raise `work_mem` for the session so each run holds more data and fewer runs are produced, or reduce the volume being sorted (add a `WHERE` filter, sort in partitions). A larger `work_mem` is the direct lever.

## Example

*Illustrative* — an external sort with too many runs.

```text
ERROR:  cannot have more than 4194304 runs for an external sort
```

## Related

- [cannot extend relation beyond blocks](./cannot-extend-relation-beyond-blocks.md)
- [cannot have more than 2^32-2 commands in a transaction](./cannot-have-more-than-2-32-2-commands-in-a-transaction.md)
