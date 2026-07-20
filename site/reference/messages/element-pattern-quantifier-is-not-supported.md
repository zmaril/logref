---
message: "element pattern quantifier is not supported"
slug: element-pattern-quantifier-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_graphtable.c:244"
reproduced: false
---

# `element pattern quantifier is not supported`

## What it means

A `GRAPH_TABLE` pattern used a quantifier (such as a repetition like `{1,3}` or `*`) on an element pattern. PostgreSQL's graph-pattern support does not implement quantifiers.

## When it happens

It fires while parsing a `GRAPH_TABLE ... MATCH` pattern that attaches a quantifier to a vertex or edge pattern.

## How to fix

Rewrite the query without pattern quantifiers. Match a fixed-length path explicitly, or express variable-length traversal with a recursive query (`WITH RECURSIVE`) instead of a quantified graph pattern.

## Example

*Illustrative* — a quantifier on a pattern.

```text
ERROR:  element pattern quantifier is not supported
```

## Related

- [edge pattern must be preceded by a vertex pattern](./edge-pattern-must-be-preceded-by-a-vertex-pattern.md)
- [element patterns with same variable name but different element pattern types](./element-patterns-with-same-variable-name-but-different-element-pattern-types.md)
