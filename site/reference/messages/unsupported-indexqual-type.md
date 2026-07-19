---
message: "unsupported indexqual type: %d"
slug: unsupported-indexqual-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeIndexscan.c:1631"
  - "postgres/src/backend/optimizer/plan/createplan.c:5118"
  - "postgres/src/backend/utils/adt/selfuncs.c:7497"
  - "postgres/src/backend/utils/adt/selfuncs.c:8104"
reproduced: false
---

# `unsupported indexqual type: %d`

## What it means

Internal error. Executor code building index scan conditions encountered an index-qualifier expression node of a kind it does not support. The placeholder is the node tag. The planner should only ever produce index quals the executor can handle, so an unsupported one is a consistency guard.

## When it happens

It does not arise from ordinary SQL. Reaching it points to a planner/executor mismatch or to a custom index access method or operator class producing an unexpected qual — a bug rather than a query mistake.

## How to fix

Treat it as an internal bug. If a non-core index access method or operator class is involved, suspect that extension. Capture the query and its plan and report it.

## Example

*Illustrative* — emitted internally during index-scan setup.

```text
ERROR:  unsupported indexqual type: 305
```

## Related

- [unrecognized set op](./unrecognized-set-op.md)
- [could not find hash function for hash operator](./could-not-find-hash-function-for-hash-operator.md)
