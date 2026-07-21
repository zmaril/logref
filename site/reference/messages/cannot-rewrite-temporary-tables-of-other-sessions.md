---
message: "cannot rewrite temporary tables of other sessions"
slug: cannot-rewrite-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6039"
reproduced: false
---

# `cannot rewrite temporary tables of other sessions`

## What it means

An operation that rewrites a table's storage touched a temporary table belonging to another session. Temporary tables are private to their creating session, so this session cannot rewrite one.

## When it happens

It occurs when a rewriting `ALTER TABLE`, or a bulk operation, encounters another backend's temporary table.

## How to fix

Operate only on your own session's temporary tables or on permanent tables. Exclude other sessions' temporary objects from the operation.

## Example

*Illustrative* — rewriting another session's temp table.

```text
ERROR:  cannot rewrite temporary tables of other sessions
```

## Related

- [cannot reindex temporary tables of other sessions](./cannot-reindex-temporary-tables-of-other-sessions.md)
- [cannot rewrite system relation](./cannot-rewrite-system-relation.md)
