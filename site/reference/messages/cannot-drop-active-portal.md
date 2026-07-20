---
message: "cannot drop active portal \"%s\""
slug: cannot-drop-active-portal
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_CURSOR_STATE
    code: "24000"
call_sites:
  - "postgres/src/backend/utils/mmgr/portalmem.c:486"
reproduced: false
---

# `cannot drop active portal "%s"`

## What it means

An internal guard: code tried to drop a portal — a query execution context — that is currently active. The portal is in the middle of running, so destroying it would corrupt execution state. The placeholder is the portal name.

## When it happens

It is a can't-happen check reached if portal management tries to drop the portal that is presently executing. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the workload and any extension driving cursors and report it, since a running portal should never be dropped.

## Example

*Illustrative* — dropping an active portal.

```text
ERROR:  cannot drop active portal "c"
```

## Related

- [cannot drop pinned portal](./cannot-drop-pinned-portal.md)
- [cannot commit while a portal is pinned](./cannot-commit-while-a-portal-is-pinned.md)
