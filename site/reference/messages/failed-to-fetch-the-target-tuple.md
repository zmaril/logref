---
message: "failed to fetch the target tuple"
slug: failed-to-fetch-the-target-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:3593"
  - "postgres/src/backend/executor/nodeModifyTable.c:3927"
reproduced: false
---

# `failed to fetch the target tuple`

## What it means

Internal error during an `UPDATE`/`DELETE` (or `MERGE`). The executor could not fetch the target row it had already identified for modification. It is a consistency guard in the modify-table path.

## When it happens

It fires when the row a plan located could not be re-fetched to apply the change. Ordinary updates work normally; this indicates an unexpected state, sometimes tied to corruption.

## How to fix

This is a can't-happen guard. If it recurs, check the target table and its indexes for corruption and storage health, and report a reproducible case.

## Example

*Illustrative* — the target row could not be fetched.

```text
ERROR:  failed to fetch the target tuple
```

## Related

- [failed to fetch tuple for EvalPlanQual recheck](./failed-to-fetch-tuple-for-evalplanqual-recheck.md)
- [failed to fetch conflicting tuple for ON CONFLICT](./failed-to-fetch-conflicting-tuple-for-on-conflict.md)
