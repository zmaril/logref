---
message: "cannot change relation \"%s\""
slug: cannot-change-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1193"
reproduced: false
---

# `cannot change relation "%s"`

## What it means

A data-modifying statement targeted a relation kind that cannot be written to through ordinary `INSERT`/`UPDATE`/`DELETE`. The relation is not an updatable table — for example a special catalog or an object that does not accept row changes. The placeholder is the relation name.

## When it happens

It occurs when a write statement names a relation whose kind does not support direct row modification.

## How to fix

Direct the write at an ordinary table, or use the operation appropriate to the relation kind. Confirm the target is a regular table before issuing data-modifying statements.

## Example

*Illustrative* — writing to an unmodifiable relation.

```text
ERROR:  cannot change relation "r"
```

## Related

- [cannot change materialized view](./cannot-change-materialized-view.md)
- [cannot change sequence](./cannot-change-sequence.md)
