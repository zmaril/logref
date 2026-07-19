---
message: "could not fetch default options"
slug: could-not-fetch-default-options
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/scripts/pg_isready.c:154"
reproduced: false
---

# `could not fetch default options`

## What it means

`pg_isready` could not read libpq's default connection options while preparing to test a server. Without them it cannot build the connection string to probe.

## When it happens

It happens at `pg_isready` startup when libpq's option-defaults lookup fails, an unusual condition generally tied to a broken libpq environment.

## How to fix

This points at a problem with the client environment rather than the target server. Check that the libpq installation is intact and environment variables such as `PGSERVICEFILE` point at valid files, then retry.

## Example

*Illustrative* — default-option lookup failing.

```text
pg_isready: error: could not fetch default options
```

## Related

- [could not connect to database: out of memory](./could-not-connect-to-database-out-of-memory.md)
- [could not fetch file list](./could-not-fetch-file-list.md)
