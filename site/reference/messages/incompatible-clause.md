---
message: "incompatible clause"
slug: incompatible-clause
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/statistics/mcv.c:1645"
  - "postgres/src/backend/statistics/mcv.c:1733"
  - "postgres/src/backend/statistics/mcv.c:1737"
reproduced: false
---

# `incompatible clause`

## What it means

Internal error. Extended-statistics selectivity code (here the MCV-list path) encountered a clause of a kind it does not handle while estimating selectivity. The placeholder-free message is a consistency check: the planner should only pass clauses that the statistics machinery supports.

## When it happens

It does not arise from ordinary SQL. It points to an internal mismatch in how a query's `WHERE` clauses were classified for extended statistics, rather than to anything in the query as written.

## How to fix

Treat it as an internal bug. As a workaround, dropping or not using the extended statistics object on the involved columns lets planning fall back to standard estimation. Capture the query and the statistics definition and report it.

## Example

*Illustrative* — emitted internally during selectivity estimation.

```text
ERROR:  incompatible clause
```

## Related

- [requested statistics kind is not yet built for statistics object](./requested-statistics-kind-is-not-yet-built-for-statistics-object.md)
- [could not find pathkey item to sort](./could-not-find-pathkey-item-to-sort.md)
