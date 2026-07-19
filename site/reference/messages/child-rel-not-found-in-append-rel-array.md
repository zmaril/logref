---
message: "child rel %d not found in append_rel_array"
slug: child-rel-not-found-in-append-rel-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:744"
  - "postgres/src/backend/optimizer/util/appendinfo.c:829"
reproduced: false
---

# `child rel %d not found in append_rel_array`

## What it means

Internal error. The planner looked up a child relation in its `append_rel_array` (the map of partition and inheritance children) and did not find the expected entry. The placeholder is the child relation index. It is a consistency check on the planner's inheritance bookkeeping.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency in how the planner tracked an inheritance or partition child, not to anything in your query.

## How to fix

Treat it as an internal bug. Capture the query and, if you can, the table's partitioning or inheritance structure, and report it. Simplifying the query over the partitioned table may sidestep the code path while a fix is pending.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  child rel 3 not found in append_rel_array
```

## Related

- [childrel is not a child of parentrel](./childrel-is-not-a-child-of-parentrel.md)
- [could not find opfamilies for equality operator](./could-not-find-opfamilies-for-equality-operator.md)
