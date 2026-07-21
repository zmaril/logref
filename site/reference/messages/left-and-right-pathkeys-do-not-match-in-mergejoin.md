---
message: "left and right pathkeys do not match in mergejoin"
slug: left-and-right-pathkeys-do-not-match-in-mergejoin
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/costsize.c:3744"
  - "postgres/src/backend/optimizer/plan/createplan.c:4668"
  - "postgres/src/backend/optimizer/plan/createplan.c:4672"
reproduced: false
---

# `left and right pathkeys do not match in mergejoin`

## What it means

Internal error. When constructing a merge join, the planner expects the sort keys of the left and right inputs to correspond one for one. It found that they did not and stopped, because a merge join can only work when both sides are ordered on matching keys.

## When it happens

It should not occur through normal query planning. Reaching it points to an internal inconsistency in the planner's pathkey bookkeeping, not to your query or data.

## How to fix

Treat it as an internal bug. Capture the query and, if possible, its plan, and report it. There is no query-side change expected to reliably trigger or avoid it, though rephrasing the join or disabling merge joins for the session may work around it temporarily.

## Example

*Illustrative* — emitted internally while planning a merge join.

```text
ERROR:  left and right pathkeys do not match in mergejoin
```

## Related

- [no tlist entry for key](./no-tlist-entry-for-key.md)
- [index key does not match expected index column](./index-key-does-not-match-expected-index-column.md)
