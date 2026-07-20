---
message: "bitmapset is empty"
slug: bitmapset-is-empty
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/bitmapset.c:809"
reproduced: false
---

# `bitmapset is empty`

## What it means

Code that required a non-empty bitmapset found one with no members. The call site assumes at least one member, so an empty set violates its precondition. It is an internal invariant.

## When it happens

It is a can't-happen guard in planner or executor code and does not arise from writing SQL.

## How to fix

There is no user action. If a plain query produced it, capture the query and plan and report it as a possible bug, noting any planner-affecting extensions.

## Example

*Illustrative* — the non-empty guard.

```text
ERROR:  bitmapset is empty
```

## Related

- [bitmapset has multiple members](./bitmapset-has-multiple-members.md)
- [bitmapset overflow](./bitmapset-overflow.md)
