---
message: "ALTER SYSTEM is not allowed in this environment"
slug: alter-system-is-not-allowed-in-this-environment
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:4525"
reproduced: false
---

# `ALTER SYSTEM is not allowed in this environment`

## What it means

An `ALTER SYSTEM` command was issued, but the server is configured to forbid it, so the change to `postgresql.auto.conf` was refused.

## When it happens

It occurs when the `allow_alter_system` setting is off (or the deployment otherwise disables it), which managed and locked-down environments use to keep configuration under external control.

## How to fix

Change the setting through the mechanism your environment provides instead of `ALTER SYSTEM` — edit `postgresql.conf`, use your platform's configuration interface, or ask an administrator. If you control the server and want `ALTER SYSTEM` available, enable `allow_alter_system`.

## Example

*Illustrative* — ALTER SYSTEM where it is disabled.

```sql
ALTER SYSTEM SET work_mem = '64MB';  -- ERROR:  ALTER SYSTEM is not allowed in this environment
```

## Related

- [alter action cannot be performed on relation](./alter-action-cannot-be-performed-on-relation.md)
- [unrecognized configuration parameter](./unrecognized-configuration-parameter.md)
