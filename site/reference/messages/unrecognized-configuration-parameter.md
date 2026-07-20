---
message: "unrecognized configuration parameter \"%s\""
slug: unrecognized-configuration-parameter
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:1047"
  - "postgres/src/backend/utils/misc/guc.c:1154"
reproduced: false
---

# `unrecognized configuration parameter "%s"`

## What it means

A configuration parameter was referenced by a name the server does not know, so it cannot be read or set.

## When it happens

It arises from `SET`, `SHOW`, `ALTER SYSTEM`, `ALTER DATABASE/ROLE ... SET`, or a line in `postgresql.conf` that names a parameter that does not exist — a typo, a removed setting, or a custom parameter whose extension is not loaded.

## Is this a problem?

The severity depends on the caller. Check the spelling against the current documentation. For a custom (dotted) parameter, ensure the owning extension is in `shared_preload_libraries` or otherwise loaded so the class is registered. Remove or correct obsolete settings left over from an upgrade.

## Example

*Illustrative* — setting a parameter that does not exist.

```sql
SET work_memory = '64MB';  -- ERROR:  unrecognized configuration parameter "work_memory"
```

## Related

- [setting not supported by this build](./setting-not-supported-by-this-build.md)
- [unrecognized authentication option name](./unrecognized-authentication-option-name.md)
