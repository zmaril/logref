---
message: "extnodename has to be supplied"
slug: extnodename-has-to-be-supplied
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/readfuncs.c:557"
reproduced: false
---

# `extnodename has to be supplied`

## What it means

An internal guard in the node-tree reader. Deserializing an `extensible-node`, it found no extension-node name where one was required. It is a format check on the internal node serialization.

## When it happens

It fires when the server reads a serialized node tree that should identify an `extensible-node` type by name and the name is missing. In normal operation these serialized forms include the name.

## How to fix

This is an internal invariant, usually from corrupted stored node data or a mismatch involving a custom-node extension, not a user error. Ensure the extension providing the custom node is loaded. If the data was produced normally and the extension is present, capture the details and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  extnodename has to be supplied
```

## Related

- [ExtensibleNodeMethods was not registered](./extensiblenodemethods-was-not-registered.md)
- [expected "[" to start datum, but got; length](./expected-to-start-datum-but-got-length.md)
