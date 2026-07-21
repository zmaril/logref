---
message: "cyclic dependency detected between extensions \"%s\" and \"%s\""
slug: cyclic-dependency-detected-between-extensions-and
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_RECURSION
    code: "42P19"
call_sites:
  - "postgres/src/backend/commands/extension.c:2106"
reproduced: false
---

# `cyclic dependency detected between extensions "%s" and "%s"`

## What it means

The extension machinery found that two extensions depend on each other, forming a cycle. The placeholders are the two extension names. Extensions must form a directed dependency graph without loops so they can be installed and dropped in order.

## When it happens

It fires during extension install, update, or dependency processing when the requires-relationships between extensions form a loop.

## How to fix

Break the cycle in the extensions' control files: two extensions cannot each require the other. Restructure so the dependency runs one way, possibly by splitting shared objects into a third extension both depend on. This is an extension-packaging problem to fix in the control metadata.

## Example

*Illustrative* — two mutually dependent extensions.

```text
ERROR:  cyclic dependency detected between extensions "ext_a" and "ext_b"
```

## Related

- [custom resource manager name is invalid](./custom-resource-manager-name-is-invalid.md)
- [data type is a domain](./data-type-is-a-domain.md)
