---
message: "adjacent vertex patterns are not supported"
slug: adjacent-vertex-patterns-are-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_graphtable.c:300"
reproduced: false
---

# `adjacent vertex patterns are not supported`

## What it means

A graph-style pattern query placed two vertex patterns next to each other without an edge between them, which the pattern parser does not accept.

## When it happens

It is raised by the property-graph/pattern-matching parser that emits this check when a path pattern lists consecutive vertex elements with no connecting edge pattern.

## How to fix

Rewrite the pattern so vertices are separated by edge patterns, following the syntax the feature accepts. If you did not intend to use graph pattern matching, check which extension or query construct produced this and correct the pattern. This is a feature-specific parser restriction.

## Example

*Illustrative* — two adjacent vertex patterns with no edge.

```text
ERROR:  adjacent vertex patterns are not supported
```

## Related

- [at or near](./at-or-near.md)
- [argument of must be a name](./argument-of-must-be-a-name.md)
