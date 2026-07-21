---
message: "unexpected end of tuplestore"
slug: unexpected-end-of-tuplestore
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:1658"
  - "postgres/src/backend/executor/nodeWindowAgg.c:1748"
  - "postgres/src/backend/executor/nodeWindowAgg.c:1833"
  - "postgres/src/backend/executor/nodeWindowAgg.c:1929"
  - "postgres/src/backend/executor/nodeWindowAgg.c:2022"
  - "postgres/src/backend/executor/nodeWindowAgg.c:2107"
  - "postgres/src/backend/executor/nodeWindowAgg.c:2379"
  - "postgres/src/backend/executor/nodeWindowAgg.c:2393"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3288"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3296"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3323"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3329"
reproduced: false
---

# `unexpected end of tuplestore`

## What it means

Internal error. A window function's executor reached the end of its buffered tuplestore before it expected to — the row it wanted to read was not there. This is a consistency guard in the window-aggregate machinery.

## When it happens

A bug in the window-function executor or in a custom window function, or memory/state corruption. Ordinary window queries do not trigger it.

## How to fix

Treat it as a bug. If a custom window function is involved, suspect it. Capture the query and a stack trace and report it. If accompanied by other corruption symptoms, check hardware/memory.

## Example

*Illustrative* — an internal window-executor guard firing.

```text
ERROR:  unexpected end of tuplestore
```

## Related

- [hash table corrupted](./hash-table-corrupted-ef89f9.md)
- [invalid tuplesort state](./invalid-tuplesort-state.md)
