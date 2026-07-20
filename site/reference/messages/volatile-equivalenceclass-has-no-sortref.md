---
message: "volatile EquivalenceClass has no sortref"
slug: volatile-equivalenceclass-has-no-sortref
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/equivclass.c:838"
  - "postgres/src/backend/optimizer/path/pathkeys.c:1080"
  - "postgres/src/backend/optimizer/plan/createplan.c:6226"
  - "postgres/src/backend/optimizer/plan/createplan.c:6765"
reproduced: false
---

# `volatile EquivalenceClass has no sortref`

## What it means

Internal error. The planner's equivalence-class machinery — which tracks sets of expressions known to be equal for sorting and join purposes — found a volatile expression class with no sort reference where one was required. It is a consistency check inside the optimizer.

## When it happens

It does not arise from ordinary SQL. Reaching it points to an optimizer bug in how a particular query's sort/grouping keys were classified, rather than to anything in the query text a user would recognize as wrong.

## How to fix

Treat it as an internal bug. Capture the query and, if possible, a minimal reproducer (the involved `ORDER BY`/`GROUP BY`/`DISTINCT` and any volatile functions in them) and report it. Rewriting the offending sort expression may sidestep it in the interim.

## Example

*Illustrative* — emitted internally by the planner.

```text
ERROR:  volatile EquivalenceClass has no sortref
```

## Related

- [could not find pathkey item to sort](./could-not-find-pathkey-item-to-sort.md)
- [could not identify an equality operator for type](./could-not-identify-an-equality-operator-for-type.md)
