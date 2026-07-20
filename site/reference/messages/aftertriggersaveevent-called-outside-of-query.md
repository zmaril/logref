---
message: "AfterTriggerSaveEvent() called outside of query"
slug: aftertriggersaveevent-called-outside-of-query
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/trigger.c:6287"
reproduced: false
---

# `AfterTriggerSaveEvent() called outside of query`

## What it means

The internal routine that queues an after-trigger event was invoked when no query was executing, so there is no context to attach the event to — an internal invariant failure.

## When it happens

It is raised when after-trigger machinery is reached outside a query, normally only through a bug or an extension calling trigger internals at the wrong time.

## How to fix

This is an internal error, not a user-facing SQL problem. If it appears, capture the statement and any extensions or triggers involved and report it. There is no query-level workaround.

## Example

*Illustrative* — the after-trigger queue used with no active query.

```text
ERROR:  AfterTriggerSaveEvent() called outside of query
```

## Related

- [aggregate function cannot register a callback in this context](./aggregate-function-cannot-register-a-callback-in-this-context.md)
- [attempt to apply a mapping to unmapped relation](./attempt-to-apply-a-mapping-to-unmapped-relation.md)
