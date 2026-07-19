---
message: "combining Aggref does not point to an Aggref"
slug: combining-aggref-does-not-point-to-an-aggref
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:11605"
reproduced: false
---

# `combining Aggref does not point to an Aggref`

## What it means

While printing or deparsing a plan, the code found a combining `Aggref` node whose reference did not resolve to a base `Aggref` as expected. This is an internal consistency check in rule/plan deparsing.

## When it happens

It fires from `ruleutils.c` when reconstructing SQL for a plan that uses partial aggregation and the aggregate node structure is not shaped as the deparser assumes.

## How to fix

This is an internal error rather than a user mistake. Note the query or view being deparsed (for example via `EXPLAIN` or `pg_get_viewdef`) and report it; there is no configuration change that resolves it.

## Example

*Illustrative* — an unexpected combining aggregate during deparse.

```text
ERROR:  combining Aggref does not point to an Aggref
```

## Related

- [combinefn not set for aggregate function](./combinefn-not-set-for-aggregate-function.md)
- [Aggref found where not expected](./aggref-found-where-not-expected.md)
