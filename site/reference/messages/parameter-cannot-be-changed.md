---
message: "parameter \"%s\" cannot be changed"
slug: parameter-cannot-be-changed
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_CANT_CHANGE_RUNTIME_PARAM
    code: "55P02"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:3388"
  - "postgres/src/backend/utils/misc/guc.c:4592"
reproduced: false
---

# `parameter "%s" cannot be changed`

## What it means

An attempt to change a configuration parameter was rejected because that parameter cannot be altered in the current context. The placeholder is the parameter name. Some parameters are fixed at server start, others can only change at session start, and some are read-only.

## When it happens

It arises from `SET`, `ALTER SYSTEM`, or `ALTER DATABASE/ROLE ... SET` on a parameter whose context does not permit that change — for example a `postmaster`-context setting like `shared_buffers` changed via `SET`.

## How to fix

Check the parameter's context in `pg_settings` (the `context` column). A `postmaster` parameter requires editing the config file and restarting the server; a `sighup` parameter needs a reload; a read-only parameter cannot be changed at all.

## Example

*Illustrative* — changing a start-time-only parameter at runtime.

```text
ERROR:  parameter "shared_buffers" cannot be changed without restarting the server
```

## Related

- [parameter "%s" cannot be set in a secondary extension control file](./parameter-cannot-be-set-in-a-secondary-extension-control-file.md)
- [permission denied to set parameter](./permission-denied-to-set-parameter.md)
