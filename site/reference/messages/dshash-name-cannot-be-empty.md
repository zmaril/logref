---
message: "DSHash name cannot be empty"
slug: dshash-name-cannot-be-empty
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_registry.c:371"
reproduced: false
---

# `DSHash name cannot be empty`

## What it means

A shared hash table (dshash) was registered through the DSM registry with an empty name. Registry entries are keyed by name, so an empty name is rejected.

## When it happens

It fires when an extension calls the DSM-registry API to get or create a named dshash and passes an empty string as the name.

## How to fix

This comes from extension or module code, not SQL. Pass a non-empty, stable name when registering a dshash. If you are only using an extension, report the empty name to its maintainer.

## Example

*Illustrative* — an empty dshash name.

```text
ERROR:  DSHash name cannot be empty
```

## Related

- [DSHash name too long](./dshash-name-too-long.md)
- [DSA name cannot be empty](./dsa-name-cannot-be-empty.md)
