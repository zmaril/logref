---
message: "cannot start a subtransaction when there are unprocessed inval messages"
slug: cannot-start-a-subtransaction-when-there-are-unprocessed-inval-messages
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/inval.c:717"
reproduced: false
---

# `cannot start a subtransaction when there are unprocessed inval messages`

## What it means

An internal guard fired: the backend tried to open a subtransaction while cache-invalidation messages from an outer command were still queued and unprocessed. Subtransaction bookkeeping expects that queue to be drained first, so this state should not occur in normal execution.

## When it happens

It is reached from subtransaction start deep inside command execution. It reflects an ordering issue in server or extension code rather than anything a query author controls.

## How to fix

There is no user-level fix. If it appears, record the statement, any extensions in use, and the surrounding server log, then report it. It points to a bug in the code path that queued the invalidations.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot start a subtransaction when there are unprocessed inval messages
```

## Related

- [cannot start commands during a parallel operation](./cannot-start-commands-during-a-parallel-operation.md)
- [cannot take query snapshot during a parallel operation](./cannot-take-query-snapshot-during-a-parallel-operation.md)
