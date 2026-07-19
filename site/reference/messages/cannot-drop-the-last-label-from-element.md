---
message: "cannot drop the last label from element \"%s\""
slug: cannot-drop-the-last-label-from-element
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:1566"
reproduced: false
---

# `cannot drop the last label from element "%s"`

## What it means

A property-graph alter tried to remove the final label from a graph element. Each vertex or edge element must keep at least one label, so removing the last one is not allowed. The placeholder is the element name.

## When it happens

It occurs when altering a property graph to drop a label from an element that has only one label left.

## How to fix

Leave at least one label on the element, or drop the element entirely if it is no longer needed. Add a replacement label before removing the last existing one.

## Example

*Illustrative* — dropping the last label.

```text
ERROR:  cannot drop the last label from element "e"
```

## Related

- [cannot change property graph](./cannot-change-property-graph.md)
- [cannot be applied to graph table](./cannot-be-applied-to-graph-table.md)
