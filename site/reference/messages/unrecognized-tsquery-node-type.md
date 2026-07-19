---
message: "unrecognized tsquery node type: %d"
slug: unrecognized-tsquery-node-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/tsquery.c:1215"
  - "postgres/src/backend/utils/adt/tsquery.c:1318"
reproduced: false
---

# `unrecognized tsquery node type: %d`

## What it means

Internal error. Code walking the parsed node tree of a `tsquery` met a node type outside the value/AND/OR/NOT/phrase set it recognizes.

## When it happens

It fires from `tsquery` processing when a node carries an unexpected type — a sign of a malformed or corrupt value, not of ordinary input.

## How to fix

This is an internal guard. If a stored `tsquery` provokes it, the value may be corrupt; capture the row and re-derive it with `to_tsquery()` to restore a clean value.

## Example

*Illustrative* — an unrecognized tsquery node.

```text
ERROR:  unrecognized tsquery node type: 7
```

## Related

- [unrecognized QueryItem type: %d](./unrecognized-queryitem-type.md)
- [unrecognized jsonb type: %d](./unrecognized-jsonb-type.md)
