---
message: "could not find inherited attribute \"%s\" of relation \"%s\""
slug: could-not-find-inherited-attribute-of-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:153"
reproduced: false
---

# `could not find inherited attribute "%s" of relation "%s"`

## What it means

The planner could not find an inherited attribute on a child relation that it expected to be there. The `%s` values name the attribute and relation. This is an internal invariant of inheritance planning.

## When it happens

It fires while the planner expands an inheritance or partition hierarchy and a parent column has no matching child attribute. Ordinary consistent hierarchies do not reach it.

## How to fix

This is an internal error. Check for a catalog inconsistency in the inheritance hierarchy or concurrent DDL during planning. Note the relation and attribute and report a reproducible case if the hierarchy is intact.

## Example

*Illustrative* — a missing inherited attribute during planning.

```text
ERROR:  could not find inherited attribute "c" of relation "child_tbl"
```

## Related

- [could not find join node](./could-not-find-join-node.md)
- [could not evaluate partition bound expression](./could-not-evaluate-partition-bound-expression.md)
