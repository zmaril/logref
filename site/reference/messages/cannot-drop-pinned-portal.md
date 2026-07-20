---
message: "cannot drop pinned portal \"%s\""
slug: cannot-drop-pinned-portal
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/utils/mmgr/portalmem.c:478"
reproduced: false
---

# `cannot drop pinned portal "%s"`

## What it means

An internal guard: code tried to drop a pinned portal — one marked as in use by the executor. A pinned portal must stay alive until it is unpinned, so dropping it is a consistency error. The placeholder is the portal name.

## When it happens

It is a can't-happen check reached if portal management tries to drop a portal that is pinned. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the workload and any cursor-driving extension and report it, since a pinned portal should never be dropped.

## Example

*Illustrative* — dropping a pinned portal.

```text
ERROR:  cannot drop pinned portal "c"
```

## Related

- [cannot drop active portal](./cannot-drop-active-portal.md)
- [cannot commit while a portal is pinned](./cannot-commit-while-a-portal-is-pinned.md)
