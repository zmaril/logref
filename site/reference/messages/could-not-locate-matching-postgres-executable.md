---
message: "%s: could not locate matching postgres executable"
slug: could-not-locate-matching-postgres-executable
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1489"
reproduced: false
---

# `%s: could not locate matching postgres executable`

## What it means

The postmaster tried to find the `postgres` backend executable that matches its own version and could not. It launches backends from this executable, so it cannot serve connections without it.

## When it happens

It fires during startup, when the matching `postgres` binary is not found next to the running program — usually a broken installation, a moved binary, or a version mismatch between the launcher and the backend.

## How to fix

Make sure the installation is complete and the `postgres` executable of the correct version is present in the expected directory alongside the program that started it. Reinstalling or repairing the package, so all binaries match, resolves it.

## Example

*Illustrative* — the matching backend executable was not found.

```text
FATAL:  postgres: could not locate matching postgres executable
```

## Related

- [could not load library](./could-not-load-library.md)
- [could not get server version](./could-not-get-server-version.md)
