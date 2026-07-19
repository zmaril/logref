---
message: "cannot operate on relation \"%s\""
slug: cannot-operate-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/contrib/pg_surgery/heap_surgery.c:112"
reproduced: false
---

# `cannot operate on relation "%s"`

## What it means

The pg_surgery extension was pointed at a relation it cannot operate on. Its surgery functions work only on ordinary heap tables with regular storage, and the target is a different kind of object. The placeholder is the relation name.

## When it happens

It occurs when `heap_force_kill()` or `heap_force_freeze()` is given a view, index, foreign table, or another object that is not a plain heap table.

## How to fix

Run the surgery function against a regular heap table. These functions are last-resort corruption-repair tools; confirm the target is the damaged heap and that you have a backup before using them.

## Example

*Illustrative* — pg_surgery on an unsupported object.

```text
ERROR:  cannot operate on relation "my_index"
```

## Related

- [cannot rewrite system relation](./cannot-rewrite-system-relation.md)
- [cannot get raw page from relation](./cannot-get-raw-page-from-relation.md)
