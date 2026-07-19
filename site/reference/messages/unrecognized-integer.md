---
message: "unrecognized integer: \"%.*s\""
slug: unrecognized-integer
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/read.c:373"
  - "postgres/src/backend/nodes/read.c:438"
  - "postgres/src/backend/nodes/readfuncs.c:237"
reproduced: false
---

# `unrecognized integer: "%.*s"`

## What it means

Internal error. The node-reading code that parses the server's internal tree representation expected an integer token and found text it could not read as one. It is a consistency check in the deserializer for stored plan and node trees.

## When it happens

It should not occur in normal operation. Reaching it points to a corrupt stored node representation or an internal inconsistency in the reader, not to your query.

## How to fix

Treat it as an internal-bug or corruption signal. If a stored expression such as a view definition or a stored rule is being read, it may be damaged; identify the object from context. Capture the details and report it.

## Example

*Illustrative* — a malformed integer token during node reading.

```text
ERROR:  unrecognized integer: "x12"
```

## Related

- [unrecognized list node type](./unrecognized-list-node-type.md)
- [unrecognized item type](./unrecognized-item-type.md)
