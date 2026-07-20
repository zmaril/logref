---
message: "cannot inherit from temporary relation \"%s\""
slug: cannot-inherit-from-temporary-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17991"
reproduced: false
---

# `cannot inherit from temporary relation "%s"`

## What it means

An inheritance clause named a temporary table as the parent for a permanent table. A permanent table cannot inherit from a temporary one because the temporary table disappears at session end. The placeholder is the relation name.

## When it happens

It occurs when a `CREATE TABLE ... INHERITS` on a permanent table points at a temporary table as the parent.

## How to fix

Inherit from a permanent table, or make the child table temporary as well if a temporary hierarchy is what you intend. Do not mix a permanent child with a temporary parent.

## Example

*Illustrative* — a permanent table inheriting from a temp table.

```text
ERROR:  cannot inherit from temporary relation "tmp_parent"
```

## Related

- [cannot inherit from temporary relation of another session](./cannot-inherit-from-temporary-relation-of-another-session.md)
- [cannot inherit to temporary relation of another session](./cannot-inherit-to-temporary-relation-of-another-session.md)
