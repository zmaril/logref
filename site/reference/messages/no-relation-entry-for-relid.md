---
message: "no relation entry for relid %d"
slug: no-relation-entry-for-relid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/relnode.c:556"
  - "postgres/src/backend/optimizer/util/relnode.c:606"
reproduced: false
---

# `no relation entry for relid %d`

## What it means

Internal error. Planner or rewriter code looked up a range-table entry by relation id and found none. The placeholder is the relid. It is a consistency guard over the query's range table.

## When it happens

It fires when a query tree references a relation that is not present in its range table — an internal inconsistency in query rewriting or planning. Ordinary queries do not surface it.

## How to fix

This is a can't-happen guard. If it follows schema changes with cached plans, reconnecting to force replanning can clear it. Capture the query and report a reproducible case.

## Example

*Illustrative* — a relid absent from the range table.

```text
ERROR:  no relation entry for relid 3
```

## Related

- [nsitem not found (internal error)](./nsitem-not-found-internal-error.md)
- [invalid varattno](./invalid-varattno.md)
