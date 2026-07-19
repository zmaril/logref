---
message: "failed to apply nullingrels to a non-Var"
slug: failed-to-apply-nullingrels-to-a-non-var
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:307"
  - "postgres/src/backend/optimizer/util/appendinfo.c:365"
reproduced: false
---

# `failed to apply nullingrels to a non-Var`

## What it means

Internal planner error. Code tried to attach outer-join nulling markers (`nullingrels`) to an expression that was not a plain Var where it required one. It is a planner-invariant guard.

## When it happens

It fires during query planning of outer joins when an expression's shape did not match what the transformation assumed. Ordinary queries do not surface it; it indicates a planner bug.

## How to fix

This is a can't-happen guard. Capture the query (especially its outer joins) and report it as a planner bug with a reproducible case.

## Example

*Illustrative* — nullingrels applied to a non-Var during planning.

```text
ERROR:  failed to apply nullingrels to a non-Var
```

## Related

- [failed to apply returningtype to a non-Var](./failed-to-apply-returningtype-to-a-non-var.md)
- [failed to find relation in joinlist](./failed-to-find-relation-in-joinlist.md)
