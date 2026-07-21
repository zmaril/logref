---
message: "no function provided to release variable stats with"
slug: no-function-provided-to-release-variable-stats-with
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/selfuncs.c:5838"
  - "postgres/src/backend/utils/adt/selfuncs.c:6065"
  - "postgres/src/backend/utils/adt/selfuncs.c:6638"
  - "postgres/src/backend/utils/adt/selfuncs.c:6664"
  - "postgres/src/backend/utils/adt/selfuncs.c:9216"
  - "postgres/src/backend/utils/adt/selfuncs.c:9248"
reproduced: false
---

# `no function provided to release variable stats with`

## What it means

Internal error. Selectivity estimation obtained per-variable statistics through a callback that returns both the stats and a matching release function, but the release step found no function was supplied. It is a bookkeeping check in the planner's statistics-hook path.

## When it happens

It should not occur with in-core code. It typically indicates a bug in an extension that implements the `get_relation_stats`/`get_variable_range` hook family without providing the paired free function.

## How to fix

Treat it as a bug in whatever provides the statistics hook. If you run a planner or FDW extension that supplies custom selectivity statistics, suspect it first and report the case to its author.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  no function provided to release variable stats with
```

## Related

- [could not determine polymorphic type](./could-not-determine-polymorphic-type.md)
- [unrecognized result from subplan](./unrecognized-result-from-subplan.md)
