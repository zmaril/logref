---
message: "cannot copy from non-table relation \"%s\""
slug: cannot-copy-from-non-table-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyto.c:870"
reproduced: false
---

# `cannot copy from non-table relation "%s"`

## What it means

A `COPY ... FROM` named a relation that is not an ordinary table. `COPY FROM` loads rows into a base table, so a relation of another kind cannot be its target. The placeholder is the relation name.

## When it happens

It occurs when `COPY relation FROM ...` names something that is not a plain table, such as a view or a partitioned parent without a suitable target.

## How to fix

Copy into an ordinary table. If you must load through a view, use an `INSTEAD OF` trigger or an underlying table instead of `COPY`.

## Example

*Illustrative* — COPY FROM into a non-table.

```text
ERROR:  cannot copy from non-table relation "r"
```

## Related

- [cannot copy to non-table relation](./cannot-copy-to-non-table-relation.md)
- [cannot copy from view](./cannot-copy-from-view.md)
