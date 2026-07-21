---
message: "relation \"%s\" does not have a composite type"
slug: relation-does-not-have-a-composite-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/nodes/makefuncs.c:152"
  - "postgres/src/backend/nodes/makefuncs.c:178"
  - "postgres/src/backend/statistics/extended_stats.c:2327"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1702"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1744"
reproduced: false
---

# `relation "%s" does not have a composite type`

## What it means

Code needed a relation's composite (row) type and the relation does not expose one. The placeholder is the relation name. Most relations (tables, views) have an associated composite type, but some object kinds — like indexes or certain internal relations — do not, so operations requiring a row type reject them.

## When it happens

Using a relation where its row type is required — for example referencing an index or a partitioned parent in a context that constructs its composite type — when that relation kind has no usable composite type.

## How to fix

Refer to a relation that has a row type (a table or view) rather than an index or other non-composite object. If you meant a specific table, correct the name. This usually indicates the wrong object kind was supplied to a row-typed context.

## Example

*Illustrative* — a relation without a composite type.

```text
ERROR:  relation "t_pkey" does not have a composite type
```

## Related

- [is not an index](./is-not-an-index.md)
- [invalid crosstab return type](./invalid-crosstab-return-type.md)
