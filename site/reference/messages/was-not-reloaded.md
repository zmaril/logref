---
message: "%s was not reloaded"
slug: was-not-reloaded
passthrough: false
api: [ereport]
level: [LOG]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:2039"
  - "postgres/src/backend/postmaster/postmaster.c:2044"
reproduced: true
---

# `%s was not reloaded`

## What it means

A configuration reload processed most settings but reports that a specific setting was not reloaded, because its new value cannot take effect without a full restart.

## When it happens

It is logged when `pg_ctl reload` (or `SELECT pg_reload_conf()`) runs and a parameter marked as requiring a restart was changed in the configuration file.

## Is this a problem?

The change is pending: the running server keeps the old value until it is restarted. Schedule a restart to apply the setting, or revert the change if you did not intend a restart-only parameter to move. Parameters with a `postmaster` context always need a restart.

## Example

*Reproduced* — captured by `reproducers/env-run.sh` (scenario `tier3__bad_hba`). The site emits a background log record; the captured line was:

```text
LOG:  /tmp/lr/env/badhba/pgdata/pg_hba.conf was not reloaded
```

## Related

- [unrecognized configuration parameter](./unrecognized-configuration-parameter.md)
- [setting not supported by this build](./setting-not-supported-by-this-build.md)
