---
message: "unrecognized QueryItem type: %d"
slug: unrecognized-queryitem-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/tsquery.c:917"
  - "postgres/src/backend/utils/adt/tsquery_util.c:144"
reproduced: false
---

# `unrecognized QueryItem type: %d`

## What it means

Internal error. Full-text-search code walking a `tsquery` met a query-item type outside the value/operator set it recognizes.

## When it happens

It fires from `tsquery` evaluation or output when an item carries an unexpected type — a sign of a malformed or corrupt `tsquery` value, not of ordinary input.

## How to fix

This is an internal guard. If a stored `tsquery` provokes it, the value may be corrupt; capture the row and re-derive the query with `to_tsquery()` to restore a clean value.

## Example

*Illustrative* — an unrecognized tsquery item.

```text
ERROR:  unrecognized QueryItem type: 3
```

## Related

- [unrecognized tsquery node type: %d](./unrecognized-tsquery-node-type.md)
- [unrecognized jsonb type: %d](./unrecognized-jsonb-type.md)
