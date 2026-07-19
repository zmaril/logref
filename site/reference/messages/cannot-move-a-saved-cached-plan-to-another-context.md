---
message: "cannot move a saved cached plan to another context"
slug: cannot-move-a-saved-cached-plan-to-another-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/plancache.c:1644"
reproduced: false
---

# `cannot move a saved cached plan to another context`

## What it means

An internal guard in the plan cache fired: code tried to move a saved cached plan into a different memory context. A saved plan owns its own context and must stay there for its lifetime, so the move is refused.

## When it happens

It is reached when caller logic attempts to reparent a saved cached plan. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or procedural code driving plan caching and report it, since saved plans must not be relocated.

## Example

*Illustrative* — relocating a saved cached plan.

```text
ERROR:  cannot move a saved cached plan to another context
```

## Related

- [cannot move a one-shot cached plan to another context](./cannot-move-a-one-shot-cached-plan-to-another-context.md)
- [cannot modify latch event](./cannot-modify-latch-event.md)
