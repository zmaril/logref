---
message: "don't have a storage tuple in this context"
slug: don-t-have-a-storage-tuple-in-this-context
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execTuples.c:389"
  - "postgres/src/backend/executor/execTuples.c:794"
reproduced: false
---

# `don't have a storage tuple in this context`

## What it means

Internal error in the executor's tuple-slot machinery. Code asked a tuple slot for its on-disk (storage) tuple in a context where the slot holds only a virtual tuple. It is a slot-type consistency guard.

## When it happens

It fires when an executor path requests a materialized storage tuple from a virtual slot. Ordinary queries do not reach it; it typically indicates a planner/executor or extension bug.

## How to fix

This is a can't-happen guard. If a custom node, FDW, or extension is involved, suspect it. Capture the query and report a reproducible case.

## Example

*Illustrative* — a storage tuple requested from a virtual slot.

```text
ERROR:  don't have a storage tuple in this context
```

## Related

- [don't have transaction information for this type of tuple](./don-t-have-transaction-information-for-this-type-of-tuple.md)
- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
