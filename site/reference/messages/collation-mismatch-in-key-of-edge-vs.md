---
message: "collation mismatch in %s key of edge \"%s\": %s vs. %s"
slug: collation-mismatch-in-key-of-edge-vs
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/propgraphcmds.c:468"
reproduced: false
---

# `collation mismatch in %s key of edge "%s": %s vs. %s`

## What it means

A property-graph definition found that the collation on one side of an edge key does not match the collation on the other side. The message names the key, the edge, and the two collations. Edge keys must agree on collation to join correctly.

## When it happens

It occurs when defining or using a property graph whose edge key columns on the source and target carry different collations.

## How to fix

Align the collations on both sides of the edge key so they match. Adjust the column definitions or add matching `COLLATE` clauses so the key columns share one collation.

## Example

*Illustrative* — mismatched edge-key collations.

```text
ERROR:  collation mismatch in source key of edge "e": "C" vs. "en_US"
```

## Related

- [collation mismatch between explicit collations and](./collation-mismatch-between-explicit-collations-and.md)
- [column has a collation conflict](./column-has-a-collation-conflict.md)
