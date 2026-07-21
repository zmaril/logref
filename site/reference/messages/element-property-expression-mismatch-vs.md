---
message: "element \"%s\" property \"%s\" expression mismatch: %s vs. %s"
slug: element-property-expression-mismatch-vs
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1143"
reproduced: false
---

# `element "%s" property "%s" expression mismatch: %s vs. %s`

## What it means

A property-graph definition gave the same property on the same element two conflicting expressions. The placeholders are the element name, the property name, and the two expressions. A property must map to one expression per element.

## When it happens

It fires while defining a property graph when a shared property across a label group resolves to different expressions on the same element.

## How to fix

Make the property resolve to a single expression for the element. Align the property definitions across the element's labels so they agree, or rename the property where the meaning differs.

## Example

*Illustrative* — conflicting property expressions.

```text
ERROR:  element "e" property "weight" expression mismatch: cost vs. price
```

## Related

- [element of property graph is not a vertex](./element-of-property-graph-is-not-a-vertex.md)
- [element label not found](./element-label-not-found.md)
