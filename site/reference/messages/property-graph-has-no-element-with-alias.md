---
message: "property graph \"%s\" has no element with alias \"%s\""
slug: property-graph-has-no-element-with-alias
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1729"
  - "postgres/src/backend/commands/propgraphcmds.c:1761"
reproduced: false
---

# `property graph "%s" has no element with alias "%s"`

## What it means

A graph query referenced an element (a vertex or edge) by an alias that the named property graph does not define. The placeholders are the property-graph name and the missing alias.

## When it happens

It arises when querying a property graph and using a label/alias in a pattern that was never declared for that graph, or that is misspelled.

## How to fix

Check the property graph's definition for the exact element aliases it exposes and use one of those. Correct the spelling or declare the element on the graph if it is genuinely missing.

## Example

*Illustrative* — referencing an undeclared graph element alias.

```text
ERROR:  property graph "social" has no element with alias "friend"
```

## Related

- [alias already exists in property graph](./alias-already-exists-in-property-graph.md)
- [procedure %s does not exist](./procedure-does-not-exist.md)
