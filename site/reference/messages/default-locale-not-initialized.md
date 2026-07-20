---
message: "default locale not initialized"
slug: default-locale-not-initialized
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:1198"
reproduced: false
---

# `default locale not initialized`

## What it means

An internal guard in the locale subsystem. Code asked for the default collation provider's locale before it was set up. This is a "should not happen" check on startup ordering, not a user error.

## When it happens

It fires when locale-dependent code runs before the database's default locale has been initialized, which points at an internal ordering problem rather than anything a query controls.

## How to fix

This is not a user-facing condition. If it appears repeatedly, capture the surrounding log and the server version. Check that the cluster was initialized cleanly (`initdb`) with a valid locale; a reproducible case is worth reporting to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  default locale not initialized
```

## Related

- [encoding does not match locale](./encoding-does-not-match-locale.md)
- [could not load locale](./could-not-load-locale.md)
