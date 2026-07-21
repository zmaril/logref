---
message: "too few entries in indexprs list"
slug: too-few-entries-in-indexprs-list
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:368"
  - "postgres/src/backend/commands/analyze.c:486"
  - "postgres/src/backend/optimizer/plan/createplan.c:5178"
  - "postgres/src/backend/parser/parse_utilcmd.c:1900"
  - "postgres/src/backend/statistics/stat_utils.c:336"
  - "postgres/src/backend/utils/adt/ruleutils.c:1453"
  - "postgres/src/backend/utils/adt/selfuncs.c:5801"
reproduced: false
---

# `too few entries in indexprs list`

## What it means

Internal error. Code building or using an index expected more expression entries in the index's `indexprs` list than it found — the count of expression columns does not match the index definition. It signals an inconsistent index definition in the catalog.

## When it happens

Catalog inconsistency in an expression index, a bug in index-definition handling, or an extension manipulating index metadata. Ordinary use of expression indexes does not trigger it.

## How to fix

`REINDEX` the affected index, or drop and recreate it from a correct definition. If the catalog `indexprs` is genuinely inconsistent, treat it as corruption and investigate (restore from backup if needed). Report reproducible cases with the index definition.

## Example

*Illustrative* — an index with inconsistent expression metadata.

```text
ERROR:  too few entries in indexprs list
```

## Related

- [wrong number of index expressions](./wrong-number-of-index-expressions.md)
- [cache lookup failed for index](./cache-lookup-failed-for-index.md)
