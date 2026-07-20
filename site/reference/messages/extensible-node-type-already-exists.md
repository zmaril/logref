---
message: "extensible node type \"%s\" already exists"
slug: extensible-node-type-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/nodes/extensible.c:64"
reproduced: false
---

# `extensible node type "%s" already exists`

## What it means

An extension tried to register an `extensible-node` type under a name that is already registered. The placeholder is the name. `extensible-node` names must be unique within a running server.

## When it happens

It fires during `extensible-node` registration when two extensions (or a double load of one) register the same node-type name.

## How to fix

This concerns extension development and loading. Ensure each extension uses a unique `extensible-node` name and registers it once. A name collision between two extensions must be resolved by their authors. If you are only a user, report the conflict to the extension maintainers.

## Example

*Illustrative* — the message as logged.

```
ERROR:  extensible node type "MyCustomScan" already exists
```

## Related

- [`extensible node name is too long`](./extensible-node-name-is-too-long.md)
- [ExtensibleNodeMethods was not registered](./extensiblenodemethods-was-not-registered.md)
