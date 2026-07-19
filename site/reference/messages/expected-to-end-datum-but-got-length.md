---
message: "expected \"]\" to end datum, but got \"%s\"; length = %zu"
slug: expected-to-end-datum-but-got-length
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/readfuncs.c:653"
reproduced: false
---

# `expected "]" to end datum, but got "%s"; length = %zu`

## What it means

An internal guard in the node-tree reader. Parsing the serialized form of a value, it expected the closing `]` that ends a datum and read something else. The placeholders are the unexpected token and its length. It is a check on the internal node-serialization format.

## When it happens

It fires when the server deserializes a stored or transmitted node tree (for example a stored expression or a plan passed between processes) and the text does not match the expected format. In normal operation these strings are well-formed.

## How to fix

This is an internal invariant that usually reflects corrupted stored node data or a version mismatch, not a user error. If it followed a crash or storage fault, investigate the affected catalog object; recreating it from its source definition may clear it. Capture the details and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected "]" to end datum, but got "foo"; length = 3
```

## Related

- [expected "[" to start datum, but got; length](./expected-to-start-datum-but-got-length.md)
- [extnodename has to be supplied](./extnodename-has-to-be-supplied.md)
