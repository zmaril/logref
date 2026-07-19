---
message: "childrel is not a child of parentrel"
slug: childrel-is-not-a-child-of-parentrel
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:612"
  - "postgres/src/backend/optimizer/util/appendinfo.c:686"
reproduced: false
---

# `childrel is not a child of parentrel`

## What it means

Internal error. The planner's append-relation code was asked to relate a child relation to a parent that is not actually its parent. It is a consistency check on the inheritance/partition parent-child mapping.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency in the planner's inheritance bookkeeping, not to anything in your query.

## How to fix

Treat it as an internal bug. Capture the query and the partitioned or inherited table structure and report it. There is no query-side change expected to trigger or avoid it reliably.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  childrel is not a child of parentrel
```

## Related

- [child rel not found in append_rel_array](./child-rel-not-found-in-append-rel-array.md)
- [cannot inherit from partitioned table](./cannot-inherit-from-partitioned-table.md)
