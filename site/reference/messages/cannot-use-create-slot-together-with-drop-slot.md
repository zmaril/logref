---
message: "cannot use --create-slot together with --drop-slot"
slug: cannot-use-create-slot-together-with-drop-slot
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:766"
reproduced: true
---

# `cannot use --create-slot together with --drop-slot`

## What it means

`pg_recvlogical` was given both `--create-slot` and `--drop-slot`. Creating a slot and dropping one are opposite actions and cannot be requested in the same invocation.

## When it happens

It occurs when `--create-slot` and `--drop-slot` appear together on the `pg_recvlogical` command line.

## How to fix

Choose one action. Run `--create-slot` on its own, or `--drop-slot` on its own, in separate commands.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__67_backup`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  cannot use --create-slot together with --drop-slot
```

## Related

- [cannot use --create-slot or --start together with --drop-slot](./cannot-use-create-slot-or-start-together-with-drop-slot.md)
- [cannot use --create-slot or --drop-slot together with --startpos](./cannot-use-create-slot-or-drop-slot-together-with-startpos.md)
