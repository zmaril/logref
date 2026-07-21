---
message: "ExtensibleNodeMethods \"%s\" was not registered"
slug: extensiblenodemethods-was-not-registered
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/nodes/extensible.c:112"
reproduced: false
---

# `ExtensibleNodeMethods "%s" was not registered`

## What it means

Server code needed the method table for an extensible node type and found none registered under that name. The placeholder is the name. It means an extension's custom node was used without its methods being registered first.

## When it happens

It fires when a stored or transmitted plan references an extensible node type whose extension is not loaded, or whose registration did not run — for example a cached plan referencing a custom node after the providing extension was removed, or a worker process that did not load the extension.

## How to fix

Ensure the extension that defines the node is loaded in every process that needs it — often via `shared_preload_libraries` so background and parallel workers also register it. If the extension was uninstalled, remove or recreate the objects that depend on its custom nodes. Extension authors must register methods before their nodes appear in plans.

## Example

*Illustrative* — the message as logged.

```
ERROR:  ExtensibleNodeMethods "MyCustomScan" was not registered
```

## Related

- [`extensible node type already exists`](./extensible-node-type-already-exists.md)
- [`extensible node name is too long`](./extensible-node-name-is-too-long.md)
