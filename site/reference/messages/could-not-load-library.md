---
message: "could not load library \"%s\": %s"
slug: could-not-load-library
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/fmgr/dfmgr.c:250"
reproduced: false
---

# `could not load library "%s": %s`

## What it means

The server tried to load a shared library — an extension module or a C function's backing file — and the operating-system loader refused. The `%s` values give the library path and the loader's reason.

## When it happens

It happens when creating or calling a C-language function, loading an extension, or preloading a library, when the file is missing, unreadable, built for the wrong architecture, or depends on something not installed.

## How to fix

Read the loader reason: a missing file usually means the library is not installed where Postgres expects; an undefined-symbol or wrong-architecture error means a build or version mismatch. Install the correct module for this server's version and platform, make it readable, and retry.

## Example

*Illustrative* — a module the loader could not open.

```text
ERROR:  could not load library "/usr/lib/postgresql/16/lib/mymod.so": /usr/lib/postgresql/16/lib/mymod.so: cannot open shared object file: No such file or directory
```

## Related

- [could not locate matching postgres executable](./could-not-locate-matching-postgres-executable.md)
- [could not load locale](./could-not-load-locale.md)
