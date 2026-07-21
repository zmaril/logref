---
message: "could not initialize GMT time zone"
slug: could-not-initialize-gmt-time-zone
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/timezone/pgtz.c:268"
reproduced: false
---

# `could not initialize GMT time zone`

## What it means

The server tried to load its built-in GMT time zone during startup and could not. GMT is a baseline zone the timestamp code always needs, so its absence stops initialization.

## When it happens

It fires very early in startup while the time-zone subsystem loads GMT, when the built-in zone data cannot be read — usually a broken or incomplete installation of the bundled time-zone files.

## How to fix

Make sure the installation's time-zone data is intact and readable (the bundled `pg_tz` data or the system zoneinfo, depending on build). Reinstalling the server files, or repairing the zoneinfo the build relies on, resolves it.

## Example

*Illustrative* — the built-in GMT zone could not be loaded.

```text
ERROR:  could not initialize GMT time zone
```

## Related

- [could not get lconv for lc_monetary lc_numeric](./could-not-get-lconv-for-lc-monetary-lc-numeric.md)
- [could not load locale](./could-not-load-locale.md)
