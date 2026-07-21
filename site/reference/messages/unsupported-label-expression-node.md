---
message: "unsupported label expression node: %d"
slug: unsupported-label-expression-node
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_graphtable.c:221"
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:884"
reproduced: false
---

# `unsupported label expression node: %d`

## What it means

Internal error. Code building or rendering a label expression (for example in `sepgsql` or a similar labeling extension) met a node type it does not support.

## When it happens

It fires where a label expression's node kind is switched on and the value is outside the supported set. Normal labeled operations do not produce it.

## How to fix

This is an internal guard. If it appears during ordinary labeled activity, capture the operation and the label involved and report it as a reproducible bug.

## Example

*Illustrative* — an unsupported label expression node.

```text
ERROR:  unsupported label expression node: 704
```

## Related

- [unsupported reference to system column %d in FieldSelect](./unsupported-reference-to-system-column-in-fieldselect.md)
- [unsupported join type %d](./unsupported-join-type.md)
