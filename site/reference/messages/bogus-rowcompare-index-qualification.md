---
message: "bogus RowCompare index qualification"
slug: bogus-rowcompare-index-qualification
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeIndexscan.c:1371"
reproduced: false
---

# `bogus RowCompare index qualification`

## What it means

The planner built an index qualification for a row-comparison expression that came out malformed. Row comparisons like `(a, b) < (1, 2)` translate into a specific index-scan condition, and this one did not have the expected shape. It is an internal guard.

## When it happens

It is a can't-happen check in index-path planning and does not arise from writing a row comparison in SQL.

## How to fix

There is no user action for ordinary queries. If it appears, capture the row-comparison query and its `EXPLAIN` output and report it as a possible planner bug.

## Example

*Illustrative* — a malformed row-compare qualifier.

```text
ERROR:  bogus RowCompare index qualification
```

## Related

- [bogus resno in targetlist](./bogus-resno-in-targetlist.md)
- [bogus lower boundary types](./bogus-lower-boundary-types.md)
