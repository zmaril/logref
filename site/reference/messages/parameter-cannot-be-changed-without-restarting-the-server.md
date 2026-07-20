---
message: "parameter \"%s\" cannot be changed without restarting the server"
slug: parameter-cannot-be-changed-without-restarting-the-server
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_CANT_CHANGE_RUNTIME_PARAM
    code: "55P02"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:465"
  - "postgres/src/backend/utils/misc/guc.c:3411"
  - "postgres/src/backend/utils/misc/guc.c:3655"
  - "postgres/src/backend/utils/misc/guc.c:3751"
  - "postgres/src/backend/utils/misc/guc.c:3847"
  - "postgres/src/backend/utils/misc/guc.c:3972"
  - "postgres/src/backend/utils/misc/guc.c:4111"
reproduced: false
---

# `parameter "%s" cannot be changed without restarting the server`

## What it means

A configuration parameter that is fixed at server start was changed, but the change cannot take effect until the server restarts. The placeholder is the parameter. These `postmaster`-context GUCs (for example `shared_buffers`, `max_connections`, `wal_level`) are read once at startup. The severity varies by how the change was attempted.

## When it happens

Editing a restart-only parameter in `postgresql.conf` and reloading (the value is staged but not active), or trying to `SET`/`ALTER SYSTEM` it and expecting an immediate effect. A reload picks up other parameters but not these.

## Is this a problem?

Restart the server for the change to take effect — a reload is not enough for these parameters. Confirm which parameters are restart-only via `pg_settings.context = 'postmaster'`. Schedule the restart during a maintenance window if the parameter matters for the workload. `pending_restart` in `pg_settings` shows parameters awaiting a restart.

## Example

*Illustrative* — reloading after changing a restart-only GUC.

```text
LOG:  parameter "shared_buffers" cannot be changed without restarting the server
```

## Related

- [invalid value for parameter](./invalid-value-for-parameter-821f2c.md)
- [database system is ready to accept connections](./database-system-is-ready-to-accept-connections.md)
