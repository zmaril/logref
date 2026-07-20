---
message: "cannot inherit to temporary relation of another session"
slug: cannot-inherit-to-temporary-relation-of-another-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18004"
reproduced: false
---

# `cannot inherit to temporary relation of another session`

## What it means

An inheritance operation targeted a temporary table that belongs to a different session as the child. Temporary tables are private to their creating session, so this session cannot attach one as an inheritance child.

## When it happens

It occurs when an `ALTER TABLE ... INHERIT` or similar operation names another session's temporary table as the child to modify.

## How to fix

Operate only on temporary tables created in your own session, or on permanent tables. Do not modify inheritance for another session's temporary objects.

## Example

*Illustrative* — targeting another session's temp table as child.

```text
ERROR:  cannot inherit to temporary relation of another session
```

## Related

- [cannot inherit from temporary relation of another session](./cannot-inherit-from-temporary-relation-of-another-session.md)
- [cannot inherit from temporary relation](./cannot-inherit-from-temporary-relation.md)
