---
message: "non-LATERAL parameter required by subquery"
slug: non-lateral-parameter-required-by-subquery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/paramassign.c:543"
  - "postgres/src/backend/optimizer/util/paramassign.c:574"
reproduced: false
---

# `non-LATERAL parameter required by subquery`

## What it means

Internal error. The planner found a subquery that references an outer parameter but is not marked `LATERAL`, a combination its bookkeeping should have ruled out earlier. It is a consistency guard in the planner.

## When it happens

It fires during planning when parameter dependencies and the lateral flag disagree. Ordinary queries either plan cleanly or report a lateral-reference error at parse time; reaching this guard points to an internal inconsistency.

## How to fix

This is a can't-happen guard. Capture the query and report a reproducible case. If it appears after an upgrade with cached plans, reconnecting to force replanning can help.

## Example

*Illustrative* — a subquery needing a non-lateral parameter.

```text
ERROR:  non-LATERAL parameter required by subquery
```

## Related

- [no relation entry for relid](./no-relation-entry-for-relid.md)
- [nsitem not found (internal error)](./nsitem-not-found-internal-error.md)
