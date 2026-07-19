---
message: "before_stmt_triggers_fired() called outside of query"
slug: before-stmt-triggers-fired-called-outside-of-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:6684"
reproduced: false
---

# `before_stmt_triggers_fired() called outside of query`

## What it means

An internal helper that tracks whether before-statement triggers have fired was called when no query is executing. It is a consistency check on trigger bookkeeping.

## When it happens

It is an internal guard. It would only surface from a bug in the trigger or executor machinery, not from writing triggers in SQL.

## How to fix

This is not something a query or trigger definition can cause directly. If it appears, capture the statement and any triggers or extensions involved and report it with the server version.

## Example

*Illustrative* — the bookkeeping guard.

```text
ERROR:  before_stmt_triggers_fired() called outside of query
```

## Related

- [before trigger's when condition cannot reference new system columns](./before-trigger-s-when-condition-cannot-reference-new-system-columns.md)
- [bogus direction](./bogus-direction.md)
