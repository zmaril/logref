---
message: "could not find pathkey item to sort"
slug: could-not-find-pathkey-item-to-sort
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/deparse.c:4001"
  - "postgres/src/backend/optimizer/plan/createplan.c:6292"
  - "postgres/src/backend/optimizer/plan/createplan.c:6793"
reproduced: false
---

# `could not find pathkey item to sort`

## What it means

Internal error. The planner or a plan node (here `postgres_fdw` deparse) needed to produce a sort key for a pathkey but could not find a matching target-list item to sort on. The placeholder-free message is an optimizer consistency check tying pathkeys to output columns.

## When it happens

It does not arise from ordinary SQL. It points to a planner bug or an FDW/custom-scan interaction where the sort key could not be mapped to an emitted column, rather than to the query as written.

## How to fix

Treat it as an internal bug. If a foreign data wrapper or custom scan is involved, suspect its interaction with sorting; disabling pushdown of the sort may be a temporary workaround. Capture the query and plan and report it.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  could not find pathkey item to sort
```

## Related

- [volatile EquivalenceClass has no sortref](./volatile-equivalenceclass-has-no-sortref.md)
- [out of binary heap slots](./out-of-binary-heap-slots.md)
