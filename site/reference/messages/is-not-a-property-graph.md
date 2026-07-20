---
message: "\"%s\" is not a property graph"
slug: is-not-a-property-graph
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1847"
  - "postgres/src/backend/catalog/objectaddress.c:1460"
  - "postgres/src/backend/commands/tablecmds.c:20399"
  - "postgres/src/backend/parser/parse_clause.c:925"
  - "postgres/src/backend/utils/adt/ruleutils.c:1639"
reproduced: false
---

# `"%s" is not a property graph`

## What it means

A command that operates on a property graph was given an object that is not one. The placeholder is the object name. Property-graph objects are a distinct kind; naming a table, view, or other relation where a property graph is required is rejected.

## When it happens

Running a property-graph-specific statement (or granting/altering privileges on one) against an object that is not a property graph.

## How to fix

Verify the object's kind with `\d name` and refer to an actual property graph, or use the command appropriate to the object you have. Correct the name if it was meant to point at a graph object.

## Example

*Illustrative* — a table used where a property graph is required.

```text
ERROR:  "t" is not a property graph
```

## Related

- [is not an index](./is-not-an-index.md)
- [relation does not have a composite type](./relation-does-not-have-a-composite-type.md)
