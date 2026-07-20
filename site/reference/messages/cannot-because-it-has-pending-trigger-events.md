---
message: "cannot %s \"%s\" because it has pending trigger events"
slug: cannot-because-it-has-pending-trigger-events
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:4523"
reproduced: false
---

# `cannot %s "%s" because it has pending trigger events`

## What it means

An `ALTER TABLE` or similar operation on a table was blocked because the table still has queued, unfired trigger events in the current transaction — usually deferred constraint checks. The operation cannot proceed while those events are pending. The first placeholder is the attempted action.

## When it happens

It occurs when you alter or drop a table in the same transaction that has deferred constraint triggers still waiting to fire against it.

## How to fix

Let the pending events resolve first: run `SET CONSTRAINTS ALL IMMEDIATE` to fire deferred checks, or commit the transaction, before attempting the table operation. Then retry the alter or drop.

## Example

*Illustrative* — altering a table with pending events.

```text
ERROR:  cannot ALTER TABLE "t" because it has pending trigger events
```

## Related

- [cannot because it is being used by active queries in this session](./cannot-because-it-is-being-used-by-active-queries-in-this-session.md)
- [cannot change relation](./cannot-change-relation.md)
