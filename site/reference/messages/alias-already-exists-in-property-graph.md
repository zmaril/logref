---
message: "alias \"%s\" already exists in property graph \"%s\""
slug: alias-already-exists-in-property-graph
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1354"
  - "postgres/src/backend/commands/propgraphcmds.c:1423"
reproduced: false
---

# `alias "%s" already exists in property graph "%s"`

## What it means

A property-graph definition reused an alias that is already defined in the same graph. Aliases within a property graph must be unique, and this one names something already aliased.

## When it happens

Defining or altering a property graph (`CREATE PROPERTY GRAPH` or the corresponding `ALTER`) where two element definitions declare the same alias.

## How to fix

Give each element a distinct alias within the graph. Rename the conflicting alias to a unique name, and review the definition for accidental duplication of vertex or edge aliases.

## Example

*Illustrative* — a duplicated alias in a property graph.

```sql
CREATE PROPERTY GRAPH g VERTEX TABLES (a AS x, b AS x);  -- alias "x" reused
```

## Related

- [alias used more than once as element table](./alias-used-more-than-once-as-element-table.md)
- [cache lookup failed for property graph element](./cache-lookup-failed-for-property-graph-element.md)
