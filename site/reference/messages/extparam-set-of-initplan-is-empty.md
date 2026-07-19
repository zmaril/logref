---
message: "extParam set of initplan is empty"
slug: extparam-set-of-initplan-is-empty
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:1330"
reproduced: false
---

# `extParam set of initplan is empty`

## What it means

An internal planner or executor guard. An initplan (a subplan evaluated once and reused) was expected to declare at least one external parameter it feeds to the outer plan, and its parameter set was empty. It is a plan-structure invariant.

## When it happens

It fires while building or running a plan containing an initplan whose parameter bookkeeping is inconsistent. In normal operation an initplan that exists to supply a parameter has a non-empty parameter set.

## How to fix

This is an internal "can't happen" invariant, not a user setting. If a routine query triggers it, capture the exact statement, table and index definitions, and the plan, and report it as a probable planner bug. There is no configuration workaround.

## Example

*Illustrative* — the message as logged.

```
ERROR:  extParam set of initplan is empty
```

## Related

- [expected just one rule action](./expected-just-one-rule-action.md)
- [ERRORDATA_STACK_SIZE exceeded](./errordata-stack-size-exceeded.md)
