---
message: "DSA name cannot be empty"
slug: dsa-name-cannot-be-empty
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_registry.c:289"
reproduced: false
---

# `DSA name cannot be empty`

## What it means

A dynamic-shared-area was registered through the DSM registry with an empty name. Registry entries are looked up by name, so an empty name is rejected.

## When it happens

It fires when an extension calls the DSM-registry API to get or create a named DSA and passes an empty string as the name.

## How to fix

This comes from extension or module code, not SQL. Pass a non-empty, stable name when registering a DSA through the DSM registry. If you are only using an extension, report the empty name to its maintainer.

## Example

*Illustrative* — an empty DSA name.

```text
ERROR:  DSA name cannot be empty
```

## Related

- [DSA name too long](./dsa-name-too-long.md)
- [DSHash name cannot be empty](./dshash-name-cannot-be-empty.md)
