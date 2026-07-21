---
message: "%s is not supported by the bump memory allocator"
slug: is-not-supported-by-the-bump-memory-allocator
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/bump.c:648"
  - "postgres/src/backend/utils/mmgr/bump.c:658"
  - "postgres/src/backend/utils/mmgr/bump.c:669"
  - "postgres/src/backend/utils/mmgr/bump.c:680"
reproduced: false
---

# `%s is not supported by the bump memory allocator`

## What it means

Internal error. The bump memory allocator — a fast, allocation-only context used for short-lived bulk allocations — was asked to perform an operation it does not implement. The placeholder names the operation. The bump allocator intentionally omits per-chunk free/realloc, so calling those trips this guard.

## When it happens

It should not occur in a correct build. Reaching it means code used a bump memory context for an operation (like freeing or reallocating an individual chunk) it does not support — a backend or extension bug, not a user action.

## How to fix

Treat it as an internal bug. If it correlates with an extension that manages memory contexts, suspect that. Capture a stack trace and report it.

## Example

*Illustrative* — emitted internally by the bump allocator.

```text
ERROR:  pfree is not supported by the bump memory allocator
```

## Related

- [could not find block containing chunk](./could-not-find-block-containing-chunk.md)
- [invalid tuplestore state](./invalid-tuplestore-state.md)
