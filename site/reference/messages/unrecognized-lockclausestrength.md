---
message: "unrecognized LockClauseStrength %d"
slug: unrecognized-lockclausestrength
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:2824"
  - "postgres/src/backend/utils/adt/ruleutils.c:6386"
reproduced: false
---

# `unrecognized LockClauseStrength %d`

## What it means

Internal error. Code handling a row-locking clause met a lock-strength value (the `FOR UPDATE`/`FOR SHARE`/`FOR NO KEY UPDATE`/`FOR KEY SHARE` selector) outside the defined set.

## When it happens

It fires where a locking clause's strength is switched on and the value is not a known case. A valid `SELECT ... FOR ...` does not produce it.

## How to fix

This is an internal consistency guard. If a real locking query triggers it, capture the query and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized lock strength.

```text
ERROR:  unrecognized LockClauseStrength 6
```

## Related

- [unrecognized LockClauseStrength (row marking)](./unrecognized-frame-option-state-0x.md)
- [WHERE CURRENT OF on a view is not implemented](./where-current-of-on-a-view-is-not-implemented.md)
