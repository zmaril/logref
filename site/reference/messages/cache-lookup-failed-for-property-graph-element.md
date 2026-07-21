---
message: "cache lookup failed for property graph element %u"
slug: cache-lookup-failed-for-property-graph-element
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4092"
  - "postgres/src/backend/catalog/objectaddress.c:6184"
  - "postgres/src/backend/commands/propgraphcmds.c:1123"
  - "postgres/src/backend/commands/propgraphcmds.c:1792"
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:773"
  - "postgres/src/backend/utils/adt/ruleutils.c:1738"
  - "postgres/src/backend/utils/adt/ruleutils.c:1755"
reproduced: false
---

# `cache lookup failed for property graph element %u`

## What it means

Internal error. A property-graph element's catalog row could not be found by OID. The placeholder is the element OID. Property graphs are a newer SQL/PGQ feature; this fires when an element (vertex/edge definition) is referenced but its catalog row is missing.

## When it happens

A concurrent drop or ALTER of a property graph while an element was still referenced, catalog inconsistency, or a bug in property-graph handling. Only affects clusters using the property-graph feature.

## How to fix

If it coincides with concurrent DDL on the property graph, retry. If it recurs, inspect the property-graph catalog for the element OID; a missing row is corruption. As a newer feature, reproducible cases are especially worth reporting with the exact DDL.

## Example

*Illustrative* — a graph element dropped mid-operation.

```text
ERROR:  cache lookup failed for property graph element 16900
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [cache lookup failed for constraint](./cache-lookup-failed-for-constraint.md)
