---
message: "cannot commit while a portal is pinned"
slug: cannot-commit-while-a-portal-is-pinned
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/portalmem.c:696"
reproduced: false
---

# `cannot commit while a portal is pinned`

## What it means

A procedure tried to commit the transaction while a pinned portal — an actively executing cursor — was open. Committing would destroy the portal that is still in use, so it is rejected. A pinned portal is one the executor is currently running within.

## When it happens

It occurs in a procedure that runs `COMMIT` while looping over a cursor or otherwise inside an active portal.

## How to fix

Finish or close the active cursor before committing. Restructure the procedure so transaction control happens outside the loop that holds the portal open.

## Example

*Illustrative* — committing with a pinned portal.

```text
ERROR:  cannot commit while a portal is pinned
```

## Related

- [cannot commit while a subtransaction is active](./cannot-commit-while-a-subtransaction-is-active.md)
- [cannot drop pinned portal](./cannot-drop-pinned-portal.md)
