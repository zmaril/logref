---
message: "alias \"%s\" used more than once as element table"
slug: alias-used-more-than-once-as-element-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_TABLE
    code: "42P07"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:144"
  - "postgres/src/backend/commands/propgraphcmds.c:187"
reproduced: false
---

# `alias "%s" used more than once as element table`

## What it means

A property-graph definition used the same alias for more than one element table. Each element table in the graph needs a distinct alias, and this alias was applied to several.

## When it happens

Defining a property graph where two or more element tables share an alias, so references to that alias would be ambiguous.

## How to fix

Assign a unique alias to each element table. Rename the duplicated aliases so every element table in the graph is referenced by its own name.

## Example

*Illustrative* — one alias covering two element tables.

```sql
CREATE PROPERTY GRAPH g VERTEX TABLES (people AS n, orgs AS n);  -- alias "n" reused
```

## Related

- [alias already exists in property graph](./alias-already-exists-in-property-graph.md)
- [table name specified more than once](./table-name-specified-more-than-once.md)
