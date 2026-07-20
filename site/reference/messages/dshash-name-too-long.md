---
message: "DSHash name too long"
slug: dshash-name-too-long
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_registry.c:375"
reproduced: false
---

# `DSHash name too long`

## What it means

A shared hash table (dshash) was registered through the DSM registry with a name longer than the fixed maximum. Registry names have a bounded length.

## When it happens

It fires when an extension registers a named dshash through the DSM registry with a name that exceeds the length limit.

## How to fix

This comes from extension or module code, not SQL. Use a shorter name within the registry's limit. If you are only using an extension, report the over-long name to its maintainer.

## Example

*Illustrative* — an over-long dshash name.

```text
ERROR:  DSHash name too long
```

## Related

- [DSHash name cannot be empty](./dshash-name-cannot-be-empty.md)
- [DSA name too long](./dsa-name-too-long.md)
