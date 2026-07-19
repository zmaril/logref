---
message: "cannot copy to non-table relation \"%s\""
slug: cannot-copy-to-non-table-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:839"
reproduced: false
---

# `cannot copy to non-table relation "%s"`

## What it means

A `COPY ... FROM` named a relation that is not an ordinary table as its load target. `COPY FROM` writes rows into a base table, so a relation of another kind cannot receive them. The placeholder is the relation name.

## When it happens

It occurs when `COPY relation FROM ...` names a non-table relation, such as a view or foreign table not set up for it.

## How to fix

Load into an ordinary table. If you need to route rows through another object, use an appropriate `INSERT` path rather than `COPY`.

## Example

*Illustrative* — COPY FROM into a non-table.

```text
ERROR:  cannot copy to non-table relation "r"
```

## Related

- [cannot copy from non-table relation](./cannot-copy-from-non-table-relation.md)
- [cannot copy to sequence](./cannot-copy-to-sequence.md)
