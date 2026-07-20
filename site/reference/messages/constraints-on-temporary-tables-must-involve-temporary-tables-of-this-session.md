---
message: "constraints on temporary tables must involve temporary tables of this session"
slug: constraints-on-temporary-tables-must-involve-temporary-tables-of-this-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10304"
reproduced: false
---

# `constraints on temporary tables must involve temporary tables of this session`

## What it means

A foreign key on a temporary table referenced a temporary table belonging to another session. Temporary tables are session-private, so a constraint may involve only this session's temporary tables.

## When it happens

It happens when defining a foreign key between temporary tables where the referenced temp table was created by a different session.

## How to fix

Reference a temporary table created in the current session, or use permanent tables if the relationship must span sessions. Cross-session temp-table references are not possible.

## Example

*Illustrative* — a temp FK referencing another session's temp table.

```text
ERROR:  constraints on temporary tables must involve temporary tables of this session
```

## Related

- [constraints on temporary tables may reference only temporary tables](./constraints-on-temporary-tables-may-reference-only-temporary-tables.md)
- [constraints on permanent tables may reference only permanent tables](./constraints-on-permanent-tables-may-reference-only-permanent-tables.md)
