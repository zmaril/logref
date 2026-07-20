---
message: "geqo failed to make a valid plan"
slug: geqo-failed-to-make-a-valid-plan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/geqo/geqo_main.c:284"
  - "postgres/src/backend/optimizer/geqo/geqo_pool.c:117"
reproduced: false
---

# `geqo failed to make a valid plan`

## What it means

Internal error in the genetic query optimizer (GEQO). Its search did not produce a valid join plan when one was expected. It is a planner-completeness guard on the GEQO path.

## When it happens

It fires when GEQO is used (many-table joins above `geqo_threshold`) and the randomized search reached an inconsistent state. Ordinary queries do not surface it.

## How to fix

As a workaround, disable GEQO (`SET geqo = off`) so the deterministic planner runs, or lower the join count. Capture the query and settings and report it as a planner bug.

## Example

*Illustrative* — GEQO produced no valid plan.

```text
ERROR:  geqo failed to make a valid plan
```

## Related

- [failed to build any-way joins](./failed-to-build-any-way-joins.md)
- [failed to JIT module](./failed-to-jit-module.md)
