---
message: "could not load %s"
slug: could-not-load-078321
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1349"
  - "postgres/src/backend/utils/init/postinit.c:238"
reproduced: false
---

# `could not load %s`

## What it means

Startup could not load a required subsystem or shared resource named by `%s` (for example a preloaded library or a description cache). Because it fires during backend or postmaster startup, the affected process cannot continue.

## When it happens

A `shared_preload_libraries` or `session_preload_libraries` entry could not be loaded, or an expected startup resource was missing or malformed. It occurs while a backend or the postmaster initializes.

## How to fix

Check the preload-library GUCs point at installed, compatible modules for this server version, and read the accompanying detail for the specific item. Correct or remove the offending entry and restart.

## Example

*Illustrative* — a preloaded library could not be loaded at startup.

```text
FATAL:  could not load library "$libdir/badmodule"
```

## Related

- [could not redirect stderr](./could-not-redirect-stderr.md)
- [could not locate my own executable path](./could-not-locate-my-own-executable-path.md)
