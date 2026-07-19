---
message: "cannot move temporary tables of other sessions"
slug: cannot-move-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3806"
reproduced: false
---

# `cannot move temporary tables of other sessions`

## What it means

A tablespace-move operation touched a temporary table that belongs to another session. Temporary tables are private to their creating session, so this session cannot move one, even though it appears in the catalog.

## When it happens

It occurs when `ALTER TABLE ALL IN TABLESPACE ... SET TABLESPACE`, or a similar bulk move, encounters another backend's temporary table in the source tablespace.

## How to fix

Exclude other sessions' temporary tables from the move — use the `OWNED BY` filter to limit the operation to specific roles, or run the move when no other sessions hold temporary tables in that tablespace.

## Example

*Illustrative* — a bulk move hitting another session's temp table.

```text
ERROR:  cannot move temporary tables of other sessions
```

## Related

- [cannot inherit from temporary relation of another session](./cannot-inherit-from-temporary-relation-of-another-session.md)
- [cannot move non-shared relation to tablespace](./cannot-move-non-shared-relation-to-tablespace.md)
