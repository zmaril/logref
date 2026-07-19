---
message: "unexpected node type in name list: %d"
slug: unexpected-node-type-in-name-list
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3685"
  - "postgres/src/backend/commands/define.c:359"
reproduced: false
---

# `unexpected node type in name list: %d`

## What it means

Internal error. Code processing a dotted name (such as a schema-qualified identifier) found a parse-tree node in the list that is not the string node it expected.

## When it happens

It fires during name resolution or deparsing when a name list contains an unexpected node kind. Well-formed statements do not produce it.

## How to fix

This is an internal consistency guard. If ordinary SQL reaches it, capture the statement and report it as a reproducible parser bug.

## Example

*Illustrative* — a malformed name list.

```text
ERROR:  unexpected node type in name list: 704
```

## Related

- [unexpected statement subtype: %d](./unexpected-statement-subtype.md)
- [unexpected rtekind: %d](./unexpected-rtekind.md)
