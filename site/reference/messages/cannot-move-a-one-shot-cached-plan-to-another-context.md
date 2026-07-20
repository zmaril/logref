---
message: "cannot move a one-shot cached plan to another context"
slug: cannot-move-a-one-shot-cached-plan-to-another-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/plancache.c:1646"
reproduced: false
---

# `cannot move a one-shot cached plan to another context`

## What it means

An internal guard in the plan cache fired: code tried to move a one-shot cached plan into a different memory context. A one-shot plan is built to run once in its own context and cannot be relocated, so the move is refused.

## When it happens

It is reached when caller logic treats a one-shot cached plan as a reusable saved plan and tries to reparent it. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or procedural code driving plan caching and report it, since one-shot plans must not be moved between contexts.

## Example

*Illustrative* — relocating a one-shot cached plan.

```text
ERROR:  cannot move a one-shot cached plan to another context
```

## Related

- [cannot move a saved cached plan to another context](./cannot-move-a-saved-cached-plan-to-another-context.md)
- [cannot modify latch event](./cannot-modify-latch-event.md)
