---
message: "unrecognized list node type: %d"
slug: unrecognized-list-node-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/equalfuncs.c:203"
  - "postgres/src/backend/nodes/outfuncs.c:314"
  - "postgres/src/backend/nodes/queryjumblefuncs.c:632"
reproduced: false
---

# `unrecognized list node type: %d`

## What it means

Internal error. Node-tree code processing a list found a list node of a type it does not recognize. Lists carry one of a small fixed set of element kinds, and this value matched none. It is a consistency check in the node infrastructure used by comparison and output routines.

## When it happens

It should not occur in normal operation. Reaching it points to an internal inconsistency in node-tree handling, not to your query.

## How to fix

Treat it as an internal bug. Capture the operation that surfaced it and report it. There is no user-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — an unrecognized list node type.

```text
ERROR:  unrecognized list node type: 17
```

## Related

- [unrecognized joinlist node type](./unrecognized-joinlist-node-type.md)
- [unrecognized integer](./unrecognized-integer.md)
