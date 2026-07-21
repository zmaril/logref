---
message: "expected \"[\" to start datum, but got \"%s\"; length = %zu"
slug: expected-to-start-datum-but-got-length
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/readfuncs.c:623"
reproduced: false
---

# `expected "[" to start datum, but got "%s"; length = %zu`

## What it means

An internal guard in the node-tree reader. Parsing the serialized form of a value, it expected the opening `[` that begins a datum and read something else. The placeholders are the unexpected token and its length.

## When it happens

It fires when deserializing an internal node tree if the text does not begin a datum where one was expected. In normal operation these serialized strings are well-formed.

## How to fix

This is an internal invariant, typically from corrupted stored node data or a version mismatch rather than a user mistake. If it followed storage problems, investigate the affected object and recreate it from source if needed. Report it with the surrounding context if the data was produced normally.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected "[" to start datum, but got "foo"; length = 3
```

## Related

- [expected "]" to end datum, but got; length](./expected-to-end-datum-but-got-length.md)
- [extnodename has to be supplied](./extnodename-has-to-be-supplied.md)
