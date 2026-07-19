---
message: "unexpected rtekind: %d"
slug: unexpected-rtekind
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:504"
  - "postgres/src/backend/optimizer/path/allpaths.c:578"
reproduced: false
---

# `unexpected rtekind: %d`

## What it means

Internal error. Planner or executor code switching on a range-table entry's kind (relation, subquery, function, values, CTE, and so on) found a kind it does not handle.

## When it happens

It fires when a query's range table holds an entry of an unexpected kind for the code path in use. Well-formed queries do not produce it.

## How to fix

This is an internal consistency guard. If a real query reaches it, capture the query and report it as a reproducible planner bug.

## Example

*Illustrative* — an unhandled range-table entry kind.

```text
ERROR:  unexpected rtekind: 12
```

## Related

- [unrecognized node type in jointree: %d](./unrecognized-node-type-in-jointree.md)
- [unexpected node type in name list: %d](./unexpected-node-type-in-name-list.md)
