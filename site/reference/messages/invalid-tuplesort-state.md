---
message: "invalid tuplesort state"
slug: invalid-tuplesort-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/tuplesort.c:1209"
  - "postgres/src/backend/utils/sort/tuplesort.c:1341"
  - "postgres/src/backend/utils/sort/tuplesort.c:1595"
  - "postgres/src/backend/utils/sort/tuplesort.c:1663"
  - "postgres/src/backend/utils/sort/tuplesort.c:2321"
  - "postgres/src/backend/utils/sort/tuplesort.c:2351"
  - "postgres/src/backend/utils/sort/tuplesort.c:2382"
reproduced: false
---

# `invalid tuplesort state`

## What it means

Internal error. The sort machinery (`tuplesort`) was used in a way that violates its state protocol — for example fetching results before the sort was finalized, or calling operations in the wrong order. It is a consistency guard in the sort code.

## When it happens

A bug in code that drives `tuplesort` (core or an extension implementing a custom sort/aggregate), or memory corruption of the sort state. Ordinary sorts do not trigger it.

## How to fix

Treat it as a bug. If an extension performs sorting via internal APIs, suspect it — the tuplesort operations must follow the required begin/put/performsort/gettuple order. Capture the query and a stack trace and report it. If accompanied by other corruption, check hardware/memory.

## Example

*Illustrative* — an internal sort-protocol guard firing.

```text
ERROR:  invalid tuplesort state
```

## Related

- [unexpected end of tuplestore](./unexpected-end-of-tuplestore.md)
- [hash table corrupted](./hash-table-corrupted-ef89f9.md)
