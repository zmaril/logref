---
message: "cannot inherit from temporary relation of another session"
slug: cannot-inherit-from-temporary-relation-of-another-session
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17998"
reproduced: false
---

# `cannot inherit from temporary relation of another session`

## What it means

An inheritance clause named a temporary table that belongs to a different session. Temporary tables are private to the session that created them, so another session cannot inherit from one.

## When it happens

It occurs when a table definition references a temporary table created by a different backend, which is visible in the catalog but not usable by this session.

## How to fix

Inherit only from a permanent table or from a temporary table created in your own session. Do not build a hierarchy on another session's temporary objects.

## Example

*Illustrative* — inheriting from another session's temp table.

```text
ERROR:  cannot inherit from temporary relation of another session
```

## Related

- [cannot inherit from temporary relation](./cannot-inherit-from-temporary-relation.md)
- [cannot inherit to temporary relation of another session](./cannot-inherit-to-temporary-relation-of-another-session.md)
