---
message: "--endpos may only be specified with --start"
slug: endpos-may-only-be-specified-with-start
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:926"
reproduced: false
---

# `--endpos may only be specified with --start`

## What it means

`pg_recvlogical` was given `--endpos` without `--start`. The end position only applies when streaming changes with `--start`.

## When it happens

It fires at `pg_recvlogical` startup when `--endpos` is supplied but the action is not `--start`.

## How to fix

Add `--start` when you use `--endpos`, since the end position bounds a streaming session. If you meant a different action (such as `--create-slot` or `--drop-slot`), drop `--endpos`.

## Example

*Illustrative* — --endpos without --start.

```text
pg_recvlogical: error: --endpos may only be specified with --start
```

## Related

- [ENDSEG is before STARTSEG](./endseg-is-before-startseg.md)
- [end WAL location is not inside file](./end-wal-location-is-not-inside-file.md)
