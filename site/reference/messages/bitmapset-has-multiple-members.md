---
message: "bitmapset has multiple members"
slug: bitmapset-has-multiple-members
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/bitmapset.c:820"
reproduced: false
---

# `bitmapset has multiple members`

## What it means

Code that expected a bitmapset holding at most one member found several. A bitmapset is a compact integer set used throughout the planner, and this call site requires a singleton. It is an internal invariant.

## When it happens

It is a can't-happen guard in planner or executor code and does not arise from ordinary SQL.

## How to fix

There is no user-facing fix. If a normal query triggered it, capture the query and plan and report it as a possible bug, along with any extensions that alter planning.

## Example

*Illustrative* — the singleton guard.

```text
ERROR:  bitmapset has multiple members
```

## Related

- [bitmapset is empty](./bitmapset-is-empty.md)
- [bitmapset overflow](./bitmapset-overflow.md)
