---
message: "cannot set options for relation \"%s\""
slug: cannot-set-options-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17419"
reproduced: false
---

# `cannot set options for relation "%s"`

## What it means

An `ALTER TABLE ... SET (...)` storage-options command targeted a relation whose kind does not accept those options. The relation is of a type that has no settable storage parameters here. The placeholder is the relation name.

## When it happens

It occurs when reloptions are set on an object — such as a view or an unsupported relation kind — that does not accept them.

## How to fix

Set storage options only on relations that support them (ordinary tables, indexes, materialized views as applicable). Choose the correct object, or use the option that matches its kind.

## Example

*Illustrative* — setting options on an unsupported relation.

```text
ERROR:  cannot set options for relation "my_view"
```

## Related

- [cannot set comment on relation](./cannot-set-comment-on-relation.md)
- [cannot set logged status of a temporary sequence](./cannot-set-logged-status-of-a-temporary-sequence.md)
