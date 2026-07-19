---
message: "cannot enable data checksums without the postmaster process"
slug: cannot-enable-data-checksums-without-the-postmaster-process
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_ADMIN_SHUTDOWN
    code: "57P01"
call_sites:
  - "postgres/src/backend/postmaster/datachecksum_state.c:917"
reproduced: false
---

# `cannot enable data checksums without the postmaster process`

## What it means

An attempt to enable data checksums on a running cluster could not proceed because the postmaster — the coordinating parent process — was not available to drive the change. Online checksum enabling is coordinated by the postmaster, so it cannot run without it.

## When it happens

It occurs when a checksum-enabling operation is invoked in a context where the postmaster is not present to manage it, such as a single-user or improperly initialized state.

## How to fix

Enable checksums through the supported path on a normally running server, or use the offline tool `pg_checksums` while the server is stopped. Do not attempt the online change without a running postmaster.

## Example

*Illustrative* — enabling checksums without the postmaster.

```text
FATAL:  cannot enable data checksums without the postmaster process
```

## Related

- [cannot create pgc_postmaster variables after startup](./cannot-create-pgc-postmaster-variables-after-startup.md)
- [cannot continue without required control information, terminating](./cannot-continue-without-required-control-information-terminating.md)
