---
message: "cannot lock rows in relation \"%s\""
slug: cannot-lock-rows-in-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1282"
reproduced: false
---

# `cannot lock rows in relation "%s"`

## What it means

A row-locking clause was applied to a relation whose kind does not support row locks. The relation is of a type — such as a partitioned parent or another non-row-storing object — that cannot lock individual rows. The placeholder is the relation name.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` reads from a relation that has no lockable row storage of its own.

## How to fix

Apply row-level locking to ordinary tables that store rows. For partitioned tables, the locking is handled through the leaf partitions; adjust the query to target lockable relations.

## Example

*Illustrative* — FOR UPDATE on a non-row-storing relation.

```text
ERROR:  cannot lock rows in relation "parent_tbl"
```

## Related

- [cannot lock relation](./cannot-lock-relation.md)
- [cannot lock rows in view](./cannot-lock-rows-in-view.md)
