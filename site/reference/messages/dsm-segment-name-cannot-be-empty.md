---
message: "DSM segment name cannot be empty"
slug: dsm-segment-name-cannot-be-empty
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_registry.c:203"
reproduced: false
---

# `DSM segment name cannot be empty`

## What it means

A dynamic-shared-memory segment was registered through the DSM registry with an empty name. Registry entries are keyed by name, so an empty name is rejected.

## When it happens

It fires when an extension calls the DSM-registry API to get or create a named segment and passes an empty string as the name.

## How to fix

This comes from extension or module code, not SQL. Pass a non-empty, stable name when registering a DSM segment. If you are only using an extension, report the empty name to its maintainer.

## Example

*Illustrative* — an empty DSM segment name.

```text
ERROR:  DSM segment name cannot be empty
```

## Related

- [DSM segment name too long](./dsm-segment-name-too-long.md)
- [DSM segment size must be nonzero](./dsm-segment-size-must-be-nonzero.md)
