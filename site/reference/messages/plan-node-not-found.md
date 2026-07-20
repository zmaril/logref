---
message: "plan node %d not found"
slug: plan-node-not-found
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execParallel.c:1109"
  - "postgres/src/backend/executor/execParallel.c:1377"
reproduced: false
---

# `plan node %d not found`

## What it means

Internal executor error. A lookup for a plan node by its identifier failed while the executor was wiring up or navigating the plan tree. The placeholder is the node number sought.

## When it happens

It fires from executor bookkeeping that resolves nodes by id — for example when connecting sub-plans or parallel state. Ordinary queries do not raise it; it indicates an inconsistent plan structure.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the statement (and any extension that produced custom plan nodes) and report it as a reproducible bug.

## Example

*Illustrative* — the executor failing to find a plan node.

```text
ERROR:  plan node 3 not found
```

## Related

- [query for CALL statement is not a CallStmt](./query-for-call-statement-is-not-a-callstmt.md)
- [subquery is bogus](./subquery-is-bogus.md)
