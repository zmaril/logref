---
message: "cannot merge using non-equality operator %u"
slug: cannot-merge-using-non-equality-operator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeMergejoin.c:226"
reproduced: false
---

# `cannot merge using non-equality operator %u`

## What it means

An internal guard in the merge-join executor fired: it was handed a join clause whose operator is not an equality operator. A merge join can only combine rows on equality, so a non-equality merge clause should never reach execution. The placeholder is the operator id.

## When it happens

It is reached when the planner produces a merge join with a clause that is not backed by an equality operator. It reflects a coding issue in planning rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query and any extension that supplies custom operators or hooks the planner and report it, since merge joins must use equality clauses.

## Example

*Illustrative* — a non-equality operator in a merge join.

```text
ERROR:  cannot merge using non-equality operator 96
```

## Related

- [cannot handle unplanned sub-select](./cannot-handle-unplanned-sub-select.md)
- [cannot merge incompatible arrays](./cannot-merge-incompatible-arrays.md)
