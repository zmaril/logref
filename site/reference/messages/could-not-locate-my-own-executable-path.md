---
message: "%s: could not locate my own executable path"
slug: could-not-locate-my-own-executable-path
passthrough: false
api: [elog, ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:1482"
  - "postgres/src/backend/utils/init/miscinit.c:207"
reproduced: false
---

# `%s: could not locate my own executable path`

## What it means

A server process could not determine the filesystem path of its own executable at startup. Postgres needs this to find sibling programs and library directories, so it stops.

## When it happens

The `/proc` self-path lookup (or the platform equivalent) failed, or the binary was invoked in a way that hid its path. It fires very early in postmaster or standalone-backend startup.

## How to fix

Start the server through its normal installed path rather than an unusual `exec` wrapper. Ensure `/proc` is mounted where the platform expects it, and that the executable has not been deleted while running.

## Example

*Illustrative* — the executable path could not be resolved at startup.

```text
postgres: could not locate my own executable path
```

## Related

- [could not load](./could-not-load-078321.md)
- [could not get control data using](./could-not-get-control-data-using-ca070c.md)
