---
message: "failed to apply returningtype to a non-Var"
slug: failed-to-apply-returningtype-to-a-non-var
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:305"
  - "postgres/src/backend/optimizer/util/appendinfo.c:363"
reproduced: false
---

# `failed to apply returningtype to a non-Var`

## What it means

Internal planner error. Code tried to apply a `RETURNING` old/new type marker to an expression that was not a plain Var where one was required. It is a planner-invariant guard for the `RETURNING` rewrite.

## When it happens

It fires while planning a data-modifying statement with `RETURNING` when an expression's shape did not match the transformation's assumption. Ordinary queries do not surface it.

## How to fix

This is a can't-happen guard. Capture the `INSERT`/`UPDATE`/`DELETE ... RETURNING` statement and report it as a planner bug with a reproduction.

## Example

*Illustrative* — a RETURNING type marker on a non-Var.

```text
ERROR:  failed to apply returningtype to a non-Var
```

## Related

- [failed to apply nullingrels to a non-Var](./failed-to-apply-nullingrels-to-a-non-var.md)
- [failed to fetch the target tuple](./failed-to-fetch-the-target-tuple.md)
