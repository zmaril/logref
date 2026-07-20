---
message: "bogus index qualification"
slug: bogus-index-qualification
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeIndexscan.c:1248"
  - "postgres/src/backend/executor/nodeIndexscan.c:1489"
reproduced: false
---

# `bogus index qualification`

## What it means

Internal error. The executor found an index-scan qualification it cannot interpret while setting up or running an index scan. It is a consistency check that the planner should have prevented.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency between the planned index conditions and what the executor expects, not to your query.

## How to fix

Treat it as an internal bug. Capture the query and, where possible, its plan, and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — emitted internally during an index scan.

```text
ERROR:  bogus index qualification
```

## Related

- [indexqual doesn't have key on left side](./indexqual-doesn-t-have-key-on-left-side.md)
- [index key does not match expected index column](./index-key-does-not-match-expected-index-column.md)
