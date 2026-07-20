---
message: "element patterns with same variable name \"%s\" but different element pattern types"
slug: element-patterns-with-same-variable-name-but-different-element-pattern-types
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/rewrite/rewriteGraphTable.c:210"
reproduced: false
---

# `element patterns with same variable name "%s" but different element pattern types`

## What it means

A `GRAPH_TABLE` pattern reused one variable name for two element patterns of different kinds — for example binding the same name to a vertex in one place and an edge in another. The placeholder is the variable name. A variable must consistently denote one element kind.

## When it happens

It fires while rewriting a graph-table pattern where the same variable name is bound to both a vertex and an edge pattern.

## How to fix

Use distinct variable names for vertex and edge patterns, or make every use of the shared name bind the same kind of element. Rename one of the conflicting bindings.

## Example

*Illustrative* — a name bound to two element kinds.

```text
ERROR:  element patterns with same variable name "x" but different element pattern types
```

## Related

- [element patterns with same variable name but different label expressions are not supported](./element-patterns-with-same-variable-name-but-different-label-expressions-are.md)
- [element pattern quantifier is not supported](./element-pattern-quantifier-is-not-supported.md)
