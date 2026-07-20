---
message: "element patterns with same variable name \"%s\" but different label expressions are not supported"
slug: element-patterns-with-same-variable-name-but-different-label-expressions-are
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:227"
reproduced: false
---

# `element patterns with same variable name "%s" but different label expressions are not supported`

## What it means

A `GRAPH_TABLE` pattern reused one variable name for element patterns with different label expressions, which PostgreSQL's graph support does not implement. The placeholder is the variable name.

## When it happens

It fires while rewriting a graph-table pattern where the same variable is bound with conflicting label expressions in different places.

## How to fix

Use the same label expression everywhere the variable appears, or give the differing patterns distinct variable names. Reconcile the label constraints so each variable has one consistent label expression.

## Example

*Illustrative* — a name with conflicting label expressions.

```text
ERROR:  element patterns with same variable name "x" but different label expressions are not supported
```

## Related

- [element patterns with same variable name but different element pattern types](./element-patterns-with-same-variable-name-but-different-element-pattern-types.md)
- [element pattern quantifier is not supported](./element-pattern-quantifier-is-not-supported.md)
