---
message: "unexpected end of tape"
slug: unexpected-end-of-tape
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/logtape.c:1095"
  - "postgres/src/backend/utils/sort/tuplesort.c:3173"
reproduced: false
---

# `unexpected end of tape`

## What it means

Internal error. During an external merge sort, a logical tape (a spilled run on disk) ended before the sort expected, so it could not read the run it was merging.

## When it happens

It fires from the tuplesort/logtape machinery when a spilled sort run is shorter than its bookkeeping indicates — a sign of a temp-file problem or an internal inconsistency, not ordinary SQL.

## How to fix

This is an internal consistency guard. Check for temp-file/disk problems (`temp_tablespaces`, disk errors, out-of-space during the sort). If storage is healthy and it recurs, capture the query and report it as a reproducible sort bug.

## Example

*Illustrative* — a sort run ending unexpectedly.

```text
ERROR:  unexpected end of tape
```

## Related

- [retrieved too many tuples in a bounded sort](./retrieved-too-many-tuples-in-a-bounded-sort.md)
- [sort key generation failed: %s](./sort-key-generation-failed.md)
