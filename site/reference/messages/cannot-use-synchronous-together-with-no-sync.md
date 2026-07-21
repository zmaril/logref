---
message: "cannot use --synchronous together with --no-sync"
slug: cannot-use-synchronous-together-with-no-sync
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:782"
reproduced: true
---

# `cannot use --synchronous together with --no-sync`

## What it means

`pg_receivewal` was given both `--synchronous` and `--no-sync`. One asks the tool to flush and confirm WAL synchronously, the other disables syncing entirely, so the two options contradict each other.

## When it happens

It occurs when `--synchronous` and `--no-sync` appear together on the `pg_receivewal` command line.

## How to fix

Pick one. Keep `--synchronous` for confirmed synchronous flushing, or `--no-sync` to skip syncing, and remove the other option.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__67_backup`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  cannot use --synchronous together with --no-sync
```

## Related

- [cannot use --create-slot together with --drop-slot](./cannot-use-create-slot-together-with-drop-slot.md)
- [cannot stream write-ahead logs in tar mode to stdout](./cannot-stream-write-ahead-logs-in-tar-mode-to-stdout.md)
