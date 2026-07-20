---
message: "requested statistics kind \"%c\" is not yet built for statistics object %u"
slug: requested-statistics-kind-is-not-yet-built-for-statistics-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/statistics/dependencies.c:704"
  - "postgres/src/backend/statistics/extended_stats.c:2465"
  - "postgres/src/backend/statistics/mcv.c:571"
  - "postgres/src/backend/statistics/mvdistinct.c:160"
reproduced: false
---

# `requested statistics kind "%c" is not yet built for statistics object %u`

## What it means

Internal error. Code asked an extended-statistics object (`CREATE STATISTICS`) for a particular statistics kind — the placeholders are the kind character and the object OID — that has not been computed for it. Extended statistics are populated by `ANALYZE`; asking for a kind before it is built is a consistency check that should not be reached by valid code paths.

## When it happens

It does not arise from ordinary querying. It points to an internal mismatch between the kinds a statistics object declares and what has actually been materialized, rather than to anything a user does directly.

## How to fix

Running `ANALYZE` on the table backing the statistics object rebuilds its statistics and is worth trying if it recurs. If it persists after a fresh `ANALYZE`, capture the statistics definition and the query and report it as a bug.

## Example

*Illustrative* — emitted internally by the extended-statistics planner code.

```text
ERROR:  requested statistics kind "d" is not yet built for statistics object 16491
```

## Related

- [cannot determine result data type](./cannot-determine-result-data-type.md)
- [incompatible clause](./incompatible-clause.md)
