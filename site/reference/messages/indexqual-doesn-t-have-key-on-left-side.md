---
message: "indexqual doesn't have key on left side"
slug: indexqual-doesn-t-have-key-on-left-side
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeIndexscan.c:1244"
  - "postgres/src/backend/executor/nodeIndexscan.c:1361"
  - "postgres/src/backend/executor/nodeIndexscan.c:1485"
reproduced: false
---

# `indexqual doesn't have key on left side`

## What it means

Internal error. An index-scan qualification is expected to have the indexed column on the left of the operator and the comparison value on the right. The executor found a qualification where that is not the case and refused to proceed.

## When it happens

It should not occur through normal SQL. The planner normalizes index conditions into this shape before execution, so reaching it points to an internal inconsistency rather than to your query.

## How to fix

Treat it as an internal bug. Capture the query and its plan and report it. There is no data-side or query-side change that is expected to trigger or avoid it.

## Example

*Illustrative* — emitted internally during an index scan.

```text
ERROR:  indexqual doesn't have key on left side
```

## Related

- [index key does not match expected index column](./index-key-does-not-match-expected-index-column.md)
- [bogus index qualification](./bogus-index-qualification.md)
