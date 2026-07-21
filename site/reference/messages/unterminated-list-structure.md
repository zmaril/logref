---
message: "unterminated List structure"
slug: unterminated-list-structure
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/read.c:357"
  - "postgres/src/backend/nodes/read.c:368"
  - "postgres/src/backend/nodes/read.c:389"
  - "postgres/src/backend/nodes/read.c:410"
  - "postgres/src/backend/nodes/read.c:455"
reproduced: false
---

# `unterminated List structure`

## What it means

Internal error. The node-tree reader (used to deserialize stored plans, rules, and other node structures from their text form) hit the end of input while still inside a list that was never closed. It is a parse-integrity check on serialized node data.

## When it happens

It should not occur for data Postgres itself serialized. Reaching it suggests corrupted stored node text (for example a damaged rule or stored expression) or a bug in code that constructs serialized nodes.

## How to fix

Treat it as an internal bug or catalog corruption. If it involves a specific view/rule or stored expression, that object's serialized form may be damaged — consider recreating it. Capture the object and report it.

## Example

*Illustrative* — emitted internally by the node reader.

```text
ERROR:  unterminated List structure
```

## Related

- [unrecognized RTE kind](./unrecognized-rte-kind.md)
- [could not parse invalid element in expression](./could-not-parse-invalid-element-in-expression.md)
