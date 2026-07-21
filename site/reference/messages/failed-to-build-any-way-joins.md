---
message: "failed to build any %d-way joins"
slug: failed-to-build-any-way-joins
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:4052"
  - "postgres/src/backend/optimizer/path/joinrels.c:260"
reproduced: false
---

# `failed to build any %d-way joins`

## What it means

Internal planner error. The join-search stage produced no valid join of a given size when it should have found at least one. The `%d` is the join level. It is a planner-completeness guard.

## When it happens

It fires during join planning when constraints left no buildable join at a level the planner expected to fill. Ordinary queries do not surface it; it indicates a planner bug or an unusual join structure.

## How to fix

This is a can't-happen guard. Capture the query (its joins and any join-order constraints) and report it as a planner bug with a reproducible case.

## Example

*Illustrative* — no valid joins at a level.

```text
ERROR:  failed to build any 2-way joins
```

## Related

- [failed to find relation in joinlist](./failed-to-find-relation-in-joinlist.md)
- [geqo failed to make a valid plan](./geqo-failed-to-make-a-valid-plan.md)
