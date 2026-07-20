---
message: "archive modules have to define the symbol %s"
slug: archive-modules-have-to-define-the-symbol
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/pgarch.c:938"
reproduced: false
---

# `archive modules have to define the symbol %s`

## What it means

A configured archive module library was loaded but does not export the entry-point symbol the server needs to initialize it, so it cannot be used for archiving.

## When it happens

It occurs when `archive_library` names a module that lacks the required init symbol — a wrong library, a version mismatch, or a build that did not export it.

## How to fix

Point `archive_library` at a correct archive-module library that exports the expected init symbol, and make sure its version matches the server. If you wrote the module, export the required entry point. Verify the library path and rebuild against the matching server version if needed.

## Example

*Illustrative* — an archive module missing its init symbol.

```text
ERROR:  archive modules have to define the symbol _PG_archive_module_init
```

## Related

- [archive modules must register an archive callback](./archive-modules-must-register-an-archive-callback.md)
- [access to library is not allowed](./access-to-library-is-not-allowed.md)
