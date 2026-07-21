---
message: "bool_accum_inv called with NULL state"
slug: bool-accum-inv-called-with-null-state
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/bool.c:370"
reproduced: false
---

# `bool_accum_inv called with NULL state`

## What it means

The inverse transition function for a boolean aggregate was invoked with a null running state. In a moving-window aggregate the state must exist before a row can be removed from it, so a null state here is an internal invariant violation.

## When it happens

It is a can't-happen guard in the moving-aggregate implementation of `bool_and`/`bool_or` and does not arise from ordinary window queries.

## How to fix

There is no user action. If a plain window query triggered it, capture the query and its frame specification and report it as a possible bug.

## Example

*Illustrative* — the null-state guard.

```text
ERROR:  bool_accum_inv called with NULL state
```

## Related

- [bitmapset is empty](./bitmapset-is-empty.md)
- [bogus direction](./bogus-direction.md)
