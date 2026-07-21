---
message: "don't have transaction information for this type of tuple"
slug: don-t-have-transaction-information-for-this-type-of-tuple
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execTuples.c:161"
  - "postgres/src/backend/executor/execTuples.c:579"
reproduced: false
---

# `don't have transaction information for this type of tuple`

## What it means

Internal error in the executor's tuple-slot machinery. Code asked for transaction (xmin/xmax) information from a slot type that does not carry it, such as a purely virtual tuple. It is a slot-type consistency guard.

## When it happens

It fires when an executor path requests visibility/transaction metadata from a slot that cannot supply it. Ordinary queries do not reach it; it points at a planner/executor or extension bug.

## How to fix

This is a can't-happen guard. Suspect any loaded FDW, custom scan, or table access method. Capture the query and report a reproducible case.

## Example

*Illustrative* — transaction info requested from a virtual slot.

```text
ERROR:  don't have transaction information for this type of tuple
```

## Related

- [don't have a storage tuple in this context](./don-t-have-a-storage-tuple-in-this-context.md)
- [failed to fetch tuple for EvalPlanQual recheck](./failed-to-fetch-tuple-for-evalplanqual-recheck.md)
