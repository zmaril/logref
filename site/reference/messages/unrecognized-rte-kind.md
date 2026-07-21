---
message: "unrecognized RTE kind: %d"
slug: unrecognized-rte-kind
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/outfuncs.c:584"
  - "postgres/src/backend/nodes/readfuncs.c:442"
  - "postgres/src/backend/optimizer/util/relnode.c:395"
  - "postgres/src/backend/parser/parse_relation.c:3226"
  - "postgres/src/backend/parser/parse_relation.c:3646"
  - "postgres/src/backend/utils/adt/ruleutils.c:13266"
reproduced: false
---

# `unrecognized RTE kind: %d`

## What it means

Internal error. Code walking the query's range table (its list of `RangeTblEntry` nodes — tables, subqueries, function scans, and so on) found an entry whose kind it does not handle. The placeholder is the numeric RTE kind. RTE kinds are a closed enumeration, so an unknown one means a malformed query tree.

## When it happens

It should not occur for queries the parser produced. Reaching it points to a bug — often in an extension that builds or rewrites query trees — or memory corruption.

## How to fix

Treat it as an internal bug. If it appears only with a particular extension (planner hooks, rewrite hooks, custom scans), suspect that extension and confirm its build matches the server. Capture the statement and report it.

## Example

*Illustrative* — emitted internally while processing a query tree.

```text
ERROR:  unrecognized RTE kind: 12
```

## Related

- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
- [negative bitmapset member not allowed](./negative-bitmapset-member-not-allowed.md)
