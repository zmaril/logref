---
message: "cannot copy a one-shot cached plan"
slug: cannot-copy-a-one-shot-cached-plan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/plancache.c:1688"
reproduced: false
---

# `cannot copy a one-shot cached plan`

## What it means

An internal guard in the plan cache: code tried to copy a one-shot cached plan. One-shot plans are built to execute a single time and are not meant to be duplicated, so copying one is a programming error.

## When it happens

It is a can't-happen check in `plancache.c`. It would only surface from a bug in code that manages cached plans, such as an extension or PL handler.

## How to fix

There is no user-level fix in SQL. If it appears, capture the statement and any extension in use and report it, since it points to incorrect plan-cache handling.

## Example

*Illustrative* — copying a one-shot plan.

```text
ERROR:  cannot copy a one-shot cached plan
```

## Related

- [cannot apply resourceowner to non-saved cached plan](./cannot-apply-resourceowner-to-non-saved-cached-plan.md)
- [cannot commute non-binary-operator clause](./cannot-commute-non-binary-operator-clause.md)
