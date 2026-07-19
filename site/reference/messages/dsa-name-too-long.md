---
message: "DSA name too long"
slug: dsa-name-too-long
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_registry.c:293"
reproduced: false
---

# `DSA name too long`

## What it means

A dynamic-shared-area was registered through the DSM registry with a name longer than the fixed maximum. Registry names have a bounded length.

## When it happens

It fires when an extension registers a named DSA through the DSM registry with a name that exceeds the length limit.

## How to fix

This comes from extension or module code, not SQL. Use a shorter name within the registry's limit. If you are only using an extension, report the over-long name to its maintainer.

## Example

*Illustrative* — an over-long DSA name.

```text
ERROR:  DSA name too long
```

## Related

- [DSA name cannot be empty](./dsa-name-cannot-be-empty.md)
- [DSHash name too long](./dshash-name-too-long.md)
