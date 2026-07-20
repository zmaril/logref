---
message: "invalid paramid: %d"
slug: invalid-paramid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/clauses.c:5703"
  - "postgres/src/backend/optimizer/util/clauses.c:6238"
reproduced: false
---

# `invalid paramid: %d`

## What it means

Internal error. The executor encountered a parameter node whose parameter id does not correspond to any parameter in the current execution context. The placeholder is the bad id. It is a consistency guard over `PARAM` node evaluation.

## When it happens

It fires when a plan references a parameter slot that is not set up — often a plan/parameter mismatch after catalog changes, or an internal bug in plan construction. Ordinary queries do not surface it.

## How to fix

This is a can't-happen guard. If it follows schema changes with cached plans, reconnecting to force replanning can clear it. Capture the query and report a reproducible case.

## Example

*Illustrative* — a parameter id with no matching parameter.

```text
ERROR:  invalid paramid: -1
```

## Related

- [no value found for parameter](./no-value-found-for-parameter.md)
- [invalid varattno](./invalid-varattno.md)
