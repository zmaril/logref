---
message: "could not map anonymous shared memory: %m"
slug: could-not-map-anonymous-shared-memory
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:656"
reproduced: false
---

# `could not map anonymous shared memory: %m`

## What it means

During startup the server asked the operating system for a large anonymous shared-memory region and the request failed. The `%m` reason gives the cause. This region holds the shared buffers and other server-wide structures.

## When it happens

It fires at startup, at the highest severity, when the anonymous memory mapping cannot be created — usually not enough available memory or overcommit headroom, or a too-low limit on locked or shared memory (often with huge pages).

## How to fix

Give the host enough free memory for the requested region, or lower `shared_buffers` and related settings. When `huge_pages = on`, either reserve enough huge pages or set `huge_pages = try`. The `%m` reason (for example "Cannot allocate memory") points at the specific limit to raise.

## Example

*Illustrative* — the shared-memory mapping could not be created.

```text
FATAL:  could not map anonymous shared memory: Cannot allocate memory
```

## Related

- [could not munmap() while flushing data](./could-not-munmap-while-flushing-data.md)
- [could not open lock file](./could-not-open-lock-file.md)
