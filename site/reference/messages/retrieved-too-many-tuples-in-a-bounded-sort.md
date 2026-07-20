---
message: "retrieved too many tuples in a bounded sort"
slug: retrieved-too-many-tuples-in-a-bounded-sort
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/tuplesort.c:1395"
  - "postgres/src/backend/utils/sort/tuplesort.c:1636"
reproduced: false
---

# `retrieved too many tuples in a bounded sort`

## What it means

Internal executor error. A bounded (top-N) sort, which keeps only the first N rows, ended up holding more than N tuples, violating its own invariant.

## When it happens

It fires from the tuplesort code that implements `ORDER BY ... LIMIT N` bounded sorts when the retained-tuple count exceeds the bound. Ordinary queries do not raise it.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the statement (including the `LIMIT`) and report it as a reproducible sort bug.

## Example

*Illustrative* — a bounded sort holding more than its bound.

```text
ERROR:  retrieved too many tuples in a bounded sort
```

## Related

- [unexpected end of tape](./unexpected-end-of-tape.md)
- [sort key generation failed: %s](./sort-key-generation-failed.md)
