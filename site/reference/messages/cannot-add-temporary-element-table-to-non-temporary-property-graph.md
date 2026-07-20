---
message: "cannot add temporary element table to non-temporary property graph"
slug: cannot-add-temporary-element-table-to-non-temporary-property-graph
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1334"
  - "postgres/src/backend/commands/propgraphcmds.c:1384"
reproduced: false
---

# `cannot add temporary element table to non-temporary property graph`

## What it means

A property-graph command tried to include a temporary table as an element (vertex or edge) table of a property graph that is not itself temporary. A permanent graph object cannot depend on a table that vanishes at session end.

## When it happens

Defining or altering a permanent property graph to reference a `TEMPORARY` table as one of its element tables.

## How to fix

Use a permanent table as the element table of a permanent property graph, or make the property graph temporary if all its element tables are temporary. Temporary and permanent lifetimes cannot be mixed in one graph definition.

## Example

*Illustrative* — referencing a temp table from a permanent graph.

```text
ERROR:  cannot add temporary element table to non-temporary property graph
```

## Related

- [cannot create a temporary relation as partition of permanent relation](./cannot-create-a-temporary-relation-as-partition-of-permanent-relation.md)
- [cannot create temporary relation in non-temporary schema](./cannot-create-temporary-relation-in-non-temporary-schema.md)
