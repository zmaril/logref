---
message: "failed to fetch conflicting tuple for ON CONFLICT"
slug: failed-to-fetch-conflicting-tuple-for-on-conflict
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:433"
  - "postgres/src/backend/executor/nodeModifyTable.c:3301"
reproduced: false
---

# `failed to fetch conflicting tuple for ON CONFLICT`

## What it means

Internal error during `INSERT ... ON CONFLICT`. After detecting a conflict, the executor could not re-fetch the conflicting existing row to run the `DO UPDATE`/`DO NOTHING` action. It is an executor consistency guard.

## When it happens

It fires when the conflicting tuple the arbiter index pointed at could not be fetched during upsert processing. Ordinary conflicts are handled normally; this signals an unexpected state.

## How to fix

This is a can't-happen guard. If it recurs, suspect index corruption on the arbiter index (reindex it) or a concurrency bug, and report a reproducible case.

## Example

*Illustrative* — the conflicting row could not be re-fetched.

```text
ERROR:  failed to fetch conflicting tuple for ON CONFLICT
```

## Related

- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
- [failed to fetch tuple for EvalPlanQual recheck](./failed-to-fetch-tuple-for-evalplanqual-recheck.md)
