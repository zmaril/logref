---
message: "negative multibitmapset member index not allowed"
slug: negative-multibitmapset-member-index-not-allowed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/multibitmapset.c:50"
  - "postgres/src/backend/nodes/multibitmapset.c:132"
reproduced: false
---

# `negative multibitmapset member index not allowed`

## What it means

Internal error. Code added a negative member index to a multibitmapset, a structure that only holds non-negative members. The negative index is rejected as a guard.

## When it happens

It fires from planner/executor internals that track sets of small integers (such as relation or column indexes) when a negative value reaches the set. Ordinary queries do not surface it; it points to an internal inconsistency.

## How to fix

This is a can't-happen guard. Capture the query and report a reproducible case. If a custom C function or extension manipulates these structures, review its index arithmetic.

## Example

*Illustrative* — a negative multibitmapset member.

```text
ERROR:  negative multibitmapset member index not allowed
```

## Related

- [invalid varattno](./invalid-varattno.md)
- [non-LATERAL parameter required by subquery](./non-lateral-parameter-required-by-subquery.md)
