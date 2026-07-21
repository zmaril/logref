---
message: "failed to fetch tuple for EvalPlanQual recheck"
slug: failed-to-fetch-tuple-for-evalplanqual-recheck
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execMain.c:2939"
  - "postgres/src/backend/executor/execMain.c:2954"
reproduced: false
---

# `failed to fetch tuple for EvalPlanQual recheck`

## What it means

Internal error during EvalPlanQual re-checking, which runs when a concurrent update forces a row to be re-evaluated. The executor could not fetch the updated row version. It is a consistency guard.

## When it happens

It fires under concurrent updates at `READ COMMITTED` when the re-check machinery could not fetch the row it expected. Ordinary concurrency is handled normally; this signals an unexpected state.

## How to fix

This is a can't-happen guard. If it recurs, check the affected table and indexes for corruption and capture the concurrent workload in a reproducible report.

## Example

*Illustrative* — the re-check row could not be fetched.

```text
ERROR:  failed to fetch tuple for EvalPlanQual recheck
```

## Related

- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
- [failed to fetch tuple1 for AFTER trigger](./failed-to-fetch-tuple1-for-after-trigger.md)
