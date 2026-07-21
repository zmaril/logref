---
message: "could not allocate memory for shared memory name"
slug: could-not-allocate-memory-for-shared-memory-name
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:79"
reproduced: false
---

# `could not allocate memory for shared memory name`

## What it means

On Windows, the server could not allocate memory to build the name of a shared-memory object during startup. This is a low-level allocation failure very early in startup.

## When it happens

It happens on Windows startup when memory allocation for a shared-memory segment name fails, typically under severe memory pressure.

## How to fix

Free system memory or reduce pressure on the host, then restart. Persistent failures at this stage point to an exhausted or misconfigured system rather than a Postgres setting; investigate overall memory usage on the machine.

## Example

*Illustrative* — a shared-memory name allocation failure.

```text
FATAL:  could not allocate memory for shared memory name
```

## Related

- [could not adopt locale nor C locale for](./could-not-adopt-locale-nor-c-locale-for.md)
- [could not attach to per-session DSM segment](./could-not-attach-to-per-session-dsm-segment.md)
