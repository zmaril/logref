---
message: "cannot take over tapes before all workers finish"
slug: cannot-take-over-tapes-before-all-workers-finish
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/tuplesort.c:3395"
reproduced: false
---

# `cannot take over tapes before all workers finish`

## What it means

An internal guard fired in the parallel external-sort code: the leader tried to take over the sorted tapes produced by its workers before every worker had reported that it finished. The tapes are only complete once all workers are done, so this state should not occur.

## When it happens

It is reached from parallel `tuplesort` merge coordination. It reflects an internal synchronization issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query, the plan, and the server log, then report it. As a stopgap you can disable parallelism with `SET max_parallel_workers_per_gather = 0`.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot take over tapes before all workers finish
```

## Related

- [cannot take query snapshot during a parallel operation](./cannot-take-query-snapshot-during-a-parallel-operation.md)
- [cannot start commands during a parallel operation](./cannot-start-commands-during-a-parallel-operation.md)
