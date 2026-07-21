---
message: "DSM segment size must be nonzero"
slug: dsm-segment-size-must-be-nonzero
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_registry.c:211"
reproduced: false
---

# `DSM segment size must be nonzero`

## What it means

A dynamic-shared-memory segment was registered through the DSM registry with a size of zero. A segment must reserve some space, so a zero size is rejected.

## When it happens

It fires when an extension registers a named DSM segment through the DSM registry and requests zero bytes.

## How to fix

This comes from extension or module code, not SQL. Request a positive segment size that matches the data you intend to store. If you are only using an extension, report the zero size to its maintainer.

## Example

*Illustrative* — a zero-size DSM segment.

```text
ERROR:  DSM segment size must be nonzero
```

## Related

- [DSM segment name cannot be empty](./dsm-segment-name-cannot-be-empty.md)
- [DSM segment name too long](./dsm-segment-name-too-long.md)
