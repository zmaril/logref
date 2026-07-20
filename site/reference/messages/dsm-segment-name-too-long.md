---
message: "DSM segment name too long"
slug: dsm-segment-name-too-long
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_registry.c:207"
reproduced: false
---

# `DSM segment name too long`

## What it means

A dynamic-shared-memory segment was registered through the DSM registry with a name longer than the fixed maximum. Registry names have a bounded length.

## When it happens

It fires when an extension registers a named DSM segment through the DSM registry with a name that exceeds the length limit.

## How to fix

This comes from extension or module code, not SQL. Use a shorter name within the registry's limit. If you are only using an extension, report the over-long name to its maintainer.

## Example

*Illustrative* — an over-long DSM segment name.

```text
ERROR:  DSM segment name too long
```

## Related

- [DSM segment name cannot be empty](./dsm-segment-name-cannot-be-empty.md)
- [DSA name too long](./dsa-name-too-long.md)
