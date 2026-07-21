---
message: "database removal failed: %s"
slug: database-removal-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/scripts/dropdb.c:156"
reproduced: true
---

# `database removal failed: %s`

## What it means

The `dropdb` command-line tool could not drop the database you named. The trailing text is the server's error explaining why.

## When it happens

It fires when `dropdb` runs its `DROP DATABASE` and the server refuses — for example the database does not exist, has active connections, or is referenced by prepared transactions.

## How to fix

Read the trailing server error. `database ... is being accessed by other users` means to disconnect sessions first (or use `--force`); `does not exist` means to check the name. Address the specific cause and rerun.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__69_scripts`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  database removal failed: %s
```

## Related

- [database creation failed](./database-creation-failed.md)
- [database is being used by prepared transactions](./database-is-being-used-by-prepared-transactions.md)
