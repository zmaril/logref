---
message: "cannot use --create-slot or --start together with --drop-slot"
slug: cannot-use-create-slot-or-start-together-with-drop-slot
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:912"
reproduced: true
---

# `cannot use --create-slot or --start together with --drop-slot`

## What it means

`pg_recvlogical` was given both a drop-slot action and a create-slot or start action. Dropping a slot and creating or streaming from one are separate modes that cannot run in a single invocation.

## When it happens

It occurs when `--drop-slot` is combined with `--create-slot` or `--start` on the `pg_recvlogical` command line.

## How to fix

Run one mode at a time. Drop the slot in one command, then create or start streaming in another.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__67_backup`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  cannot use --create-slot or --start together with --drop-slot
```

## Related

- [cannot use --create-slot together with --drop-slot](./cannot-use-create-slot-together-with-drop-slot.md)
- [cannot use --create-slot or --drop-slot together with --startpos](./cannot-use-create-slot-or-drop-slot-together-with-startpos.md)
