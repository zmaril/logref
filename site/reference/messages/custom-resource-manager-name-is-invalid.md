---
message: "custom resource manager name is invalid"
slug: custom-resource-manager-name-is-invalid
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/rmgr.c:110"
reproduced: false
---

# `custom resource manager name is invalid`

## What it means

An extension tried to register a custom WAL resource manager with an unacceptable name — empty or too long. Each resource manager needs a valid, bounded name for tools like `pg_waldump` to display.

## When it happens

It fires when a loadable extension registers a resource manager during startup and the name it supplied does not meet the length and content requirements.

## How to fix

This is an extension-development error. Give the resource manager a non-empty name within the allowed length. Correct the registration call in the extension's code and rebuild it.

## Example

*Illustrative* — an empty resource-manager name.

```text
ERROR:  custom resource manager name is invalid
```

## Related

- [custom resource manager ID is out of range](./custom-resource-manager-id-is-out-of-range.md)
- [custom resource manager does not exist](./custom-resource-manager-does-not-exist.md)
