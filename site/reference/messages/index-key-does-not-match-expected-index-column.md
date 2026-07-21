---
message: "index key does not match expected index column"
slug: index-key-does-not-match-expected-index-column
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/createplan.c:5168"
  - "postgres/src/backend/optimizer/plan/createplan.c:5195"
  - "postgres/src/backend/optimizer/plan/createplan.c:5202"
reproduced: false
---

# `index key does not match expected index column`

## What it means

Internal error. While building the plan for an index scan, the planner compared the index's declared key columns against the expression it was about to push into the scan and found they did not line up. It is a consistency check on the planner's own bookkeeping.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency between an index's catalog definition and the plan built against it, not to anything in your query or data.

## How to fix

Treat it as an internal bug. Capture the query, the `EXPLAIN` output if you can obtain it, and the index definition, and report it. A corrupt index catalog entry could also produce it, so `REINDEX` on the suspect index is worth trying if the same query keeps failing.

## Example

*Illustrative* — emitted internally during plan construction.

```text
ERROR:  index key does not match expected index column
```

## Related

- [indexqual doesn't have key on left side](./indexqual-doesn-t-have-key-on-left-side.md)
- [btree index keys must be ordered by attribute](./btree-index-keys-must-be-ordered-by-attribute.md)
