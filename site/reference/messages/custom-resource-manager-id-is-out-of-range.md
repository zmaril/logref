---
message: "custom resource manager ID %d is out of range"
slug: custom-resource-manager-id-is-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/rmgr.c:114"
reproduced: false
---

# `custom resource manager ID %d is out of range`

## What it means

An extension tried to register a custom WAL resource manager with an ID outside the range reserved for custom managers. The placeholder is the ID. Custom resource-manager IDs must fall within a fixed reserved band.

## When it happens

It fires when a loadable extension registers a resource manager during startup and the ID it requested is below or above the allowed custom range.

## How to fix

This is an extension-development error. Choose a custom resource-manager ID within the reserved range documented for the feature, and make sure two extensions do not collide on the same ID. Fix the extension's registration code and rebuild it.

## Example

*Illustrative* — an out-of-range custom manager ID.

```text
ERROR:  custom resource manager ID 5 is out of range
```

## Related

- [custom resource manager name is invalid](./custom-resource-manager-name-is-invalid.md)
- [custom resource manager does not exist](./custom-resource-manager-does-not-exist.md)
