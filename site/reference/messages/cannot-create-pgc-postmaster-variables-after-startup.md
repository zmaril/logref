---
message: "cannot create PGC_POSTMASTER variables after startup"
slug: cannot-create-pgc-postmaster-variables-after-startup
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:4795"
reproduced: false
---

# `cannot create PGC_POSTMASTER variables after startup`

## What it means

An internal guard: code tried to register a `PGC_POSTMASTER` configuration variable — one that can only be set at server start — after the postmaster had already started. Such variables must be defined during startup, so defining one later is a programming error, typically from an extension loaded at the wrong time.

## When it happens

It occurs when an extension that defines a postmaster-level GUC is loaded after startup rather than via `shared_preload_libraries`.

## How to fix

Load extensions that define postmaster-level settings through `shared_preload_libraries` so their variables register at startup. An extension defining such a variable cannot be loaded on demand into a running backend.

## Example

*Illustrative* — a postmaster GUC registered late.

```text
FATAL:  cannot create PGC_POSTMASTER variables after startup
```

## Related

- [cannot enable data checksums without the postmaster process](./cannot-enable-data-checksums-without-the-postmaster-process.md)
- [cannot create new tapes in leader process](./cannot-create-new-tapes-in-leader-process.md)
