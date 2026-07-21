---
message: "attribute %d of relation \"%s\" does not exist"
slug: attribute-of-relation-does-not-exist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:287"
  - "postgres/src/backend/optimizer/util/appendinfo.c:292"
  - "postgres/src/backend/optimizer/util/appendinfo.c:721"
  - "postgres/src/backend/optimizer/util/appendinfo.c:725"
reproduced: false
---

# `attribute %d of relation "%s" does not exist`

## What it means

Internal error. Planner code (here append-relation handling) referenced a column by attribute number on a relation that has no such attribute. The placeholders are the attribute number and the relation name. It is a consistency check between a query's column references and the relation's actual columns.

## When it happens

It should not occur for normally-planned queries. Reaching it points to a bug in query planning/rewriting or catalog inconsistency, not to your SQL.

## How to fix

Treat it as an internal bug. If it recurs on a specific view or inheritance/partition setup, that structure may be inconsistent — consider recreating it. Capture the query and report it.

## Example

*Illustrative* — emitted internally during planning.

```text
ERROR:  attribute 5 of relation "t" does not exist
```

## Related

- [attribute number not found in view targetlist](./attribute-number-not-found-in-view-targetlist.md)
- [default expression not found for attribute of relation](./default-expression-not-found-for-attribute-of-relation.md)
