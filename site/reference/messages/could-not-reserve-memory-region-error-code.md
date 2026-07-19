---
message: "could not reserve memory region: error code %lu"
slug: could-not-reserve-memory-region-error-code
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:226"
reproduced: false
---

# `could not reserve memory region: error code %lu`

## What it means

On Windows, the server could not reserve the address-space region it needs for shared memory. The trailing text is the Windows error code. Reserving the region up front keeps the shared-memory mapping at a fixed address across backends.

## When it happens

It fires during startup on Windows when the reservation call fails, typically because the required address range is already occupied or the process is out of address space.

## How to fix

This is a Windows address-space problem. It can be caused by software injecting DLLs into Postgres processes that disturb the layout; identify and exclude such tools. On heavily loaded 32-bit builds, address-space exhaustion is possible — prefer a 64-bit build. Capture the error code and log if it persists on a clean host.

## Example

*Illustrative* — the shared-memory region could not be reserved.

```text
FATAL:  could not reserve memory region: error code 487
```

## Related

- [could not reattach to shared memory (Windows error code)](./could-not-reattach-to-shared-memory-key-addr-error-code.md)
- [could not register process for wait](./could-not-register-process-for-wait-error-code.md)
