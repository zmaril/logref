---
message: "cannot create indexes on temporary tables of other sessions"
slug: cannot-create-indexes-on-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:760"
reproduced: false
---

# `cannot create indexes on temporary tables of other sessions`

## What it means

A `CREATE INDEX` targeted a temporary table that belongs to a different session. Temporary tables are private to their creating session, so another session cannot build indexes on them.

## When it happens

It occurs when indexing a temporary table owned by a different backend than the one running the command.

## How to fix

Create indexes on temporary tables from the session that owns them. Use permanent tables if indexes must be managed across sessions.

## Example

*Illustrative* — indexing another session's temp table.

```text
ERROR:  cannot create indexes on temporary tables of other sessions
```

## Related

- [cannot create index on relation](./cannot-create-index-on-relation.md)
- [cannot attach temporary relation of another session as partition](./cannot-attach-temporary-relation-of-another-session-as-partition.md)
