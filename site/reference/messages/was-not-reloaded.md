---
message: "%s was not reloaded"
slug: was-not-reloaded
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:2039"
  - "postgres/src/backend/postmaster/postmaster.c:2044"
reproduced: false
---

# `%s was not reloaded`

## What it means

A configuration reload processed most settings but reports that a specific setting was not reloaded, because its new value cannot take effect without a full restart.

## When it happens

It is logged when `pg_ctl reload` (or `SELECT pg_reload_conf()`) runs and a parameter marked as requiring a restart was changed in the configuration file.

## Is this a problem?

The change is pending: the running server keeps the old value until it is restarted. Schedule a restart to apply the setting, or revert the change if you did not intend a restart-only parameter to move. Parameters with a `postmaster` context always need a restart.

## Example

*Illustrative* — a restart-only setting changed during a reload.

```text
LOG:  shared_buffers was not reloaded
```

## Related

- [unrecognized configuration parameter](./unrecognized-configuration-parameter.md)
- [setting not supported by this build](./setting-not-supported-by-this-build.md)
