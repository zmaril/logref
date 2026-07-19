---
message: "extensible node name is too long"
slug: extensible-node-name-is-too-long
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/extensible.c:58"
reproduced: false
---

# `extensible node name is too long`

## What it means

An internal guard for the `extensible-node` mechanism, which lets extensions register custom plan or parse nodes. A registered node name exceeded the fixed maximum length. This concerns extension development, not ordinary SQL.

## When it happens

It fires when an extension calls `RegisterExtensibleNodeMethods` (or a related registration function) with a node name longer than the internal limit.

## How to fix

This is a limit for extension authors, not a database user. If you maintain the extension, shorten the `extensible-node` name to fit within the maximum. If you are only using the extension, report the name-length problem to its author.

## Example

*Illustrative* — the message as logged.

```
ERROR:  extensible node name is too long
```

## Related

- [`extensible node type already exists`](./extensible-node-type-already-exists.md)
- [ExtensibleNodeMethods was not registered](./extensiblenodemethods-was-not-registered.md)
