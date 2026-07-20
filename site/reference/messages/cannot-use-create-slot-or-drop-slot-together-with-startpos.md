---
message: "cannot use --create-slot or --drop-slot together with --startpos"
slug: cannot-use-create-slot-or-drop-slot-together-with-startpos
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:919"
reproduced: false
---

# `cannot use --create-slot or --drop-slot together with --startpos`

## What it means

`pg_recvlogical` was given a slot create or drop action together with `--startpos`. A start position only applies to streaming, so it cannot be combined with the create-slot or drop-slot modes.

## When it happens

It occurs when `pg_recvlogical --create-slot` or `--drop-slot` is run with `--startpos` (`-I`) on the command line.

## How to fix

Use `--startpos` only with `--start`. Remove it when creating or dropping a slot, and run the streaming command separately with the start position you want.

## Example

*Illustrative* — startpos with a slot action.

```text
pg_recvlogical: error: cannot use --create-slot or --drop-slot together with --startpos
```

## Related

- [cannot use --create-slot or --start together with --drop-slot](./cannot-use-create-slot-or-start-together-with-drop-slot.md)
- [cannot use --create-slot together with --drop-slot](./cannot-use-create-slot-together-with-drop-slot.md)
