---
message: "unrecognized joinlist node type: %d"
slug: unrecognized-joinlist-node-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:3887"
  - "postgres/src/backend/optimizer/plan/analyzejoins.c:951"
  - "postgres/src/backend/optimizer/plan/analyzejoins.c:2503"
reproduced: false
---

# `unrecognized joinlist node type: %d`

## What it means

Internal error. The planner walked a query's join-list structure and found a node whose type it does not recognize there. The join list holds a fixed set of node kinds, and this one matched none. It is a consistency check in the optimizer.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency in the planner's join-list handling, not to your query.

## How to fix

Treat it as an internal bug. Capture the query and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unrecognized join-list node.

```text
ERROR:  unrecognized joinlist node type: 200
```

## Related

- [unrecognized list node type](./unrecognized-list-node-type.md)
- [no plan was made for cte](./no-plan-was-made-for-cte.md)
