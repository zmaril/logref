---
message: "cannot change persistence setting twice"
slug: cannot-change-persistence-setting-twice
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:5248"
reproduced: false
---

# `cannot change persistence setting twice`

## What it means

A single `ALTER TABLE` statement tried to set the table's persistence more than once — for example both `SET LOGGED` and `SET UNLOGGED`. Only one persistence change is allowed per command.

## When it happens

It occurs when one `ALTER TABLE` includes two conflicting or duplicate persistence actions.

## How to fix

Include a single `SET LOGGED` or `SET UNLOGGED` action per statement. Decide the target persistence and specify it once.

## Example

*Illustrative* — two persistence changes.

```sql
ALTER TABLE t SET LOGGED, SET UNLOGGED;
```

## Related

- [cannot change logged status of table because it is temporary](./cannot-change-logged-status-of-table-because-it-is-temporary.md)
- [cannot alter type of column twice](./cannot-alter-type-of-column-twice.md)
