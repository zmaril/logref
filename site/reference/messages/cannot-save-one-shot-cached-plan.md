---
message: "cannot save one-shot cached plan"
slug: cannot-save-one-shot-cached-plan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/plancache.c:556"
reproduced: false
---

# `cannot save one-shot cached plan`

## What it means

An internal guard in the plan cache fired: code tried to save a one-shot cached plan for reuse. A one-shot plan is built to execute a single time and is not eligible to become a saved, reusable plan.

## When it happens

It is reached when caller logic marks a one-shot plan as saved. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or procedural code driving plan caching and report it, since one-shot plans must not be saved.

## Example

*Illustrative* — saving a one-shot cached plan.

```text
ERROR:  cannot save one-shot cached plan
```

## Related

- [cannot move a one-shot cached plan to another context](./cannot-move-a-one-shot-cached-plan-to-another-context.md)
- [cannot move a saved cached plan to another context](./cannot-move-a-saved-cached-plan-to-another-context.md)
