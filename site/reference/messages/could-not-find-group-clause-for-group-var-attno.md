---
message: "could not find GROUP clause for GROUP Var attno %d"
slug: could-not-find-group-clause-for-group-var-attno
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:1654"
reproduced: false
---

# `could not find GROUP clause for GROUP Var attno %d`

## What it means

The planner could not match a grouping `Var` back to a `GROUP BY` clause entry. The `%d` is the attribute number. This is an internal invariant in grouping-plan construction.

## When it happens

It fires while the planner builds the grouping step of an aggregate query. Reaching it points at an internal planner problem rather than anything in the SQL text.

## How to fix

This is an internal error. If a specific query triggers it, note the exact statement (especially unusual `GROUP BY`, `GROUPING SETS`, or grouped expressions) and report a reproducible case.

## Example

*Illustrative* — an unmatched grouping Var during planning.

```text
ERROR:  could not find GROUP clause for GROUP Var attno 3
```

## Related

- [could not find ordering operator for equality operator](./could-not-find-ordering-operator-for-equality-operator.md)
- [could not find replacement targetlist entry for attno](./could-not-find-replacement-targetlist-entry-for-attno.md)
