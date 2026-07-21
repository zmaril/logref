---
message: "cannot specify both output directory and backup target"
slug: cannot-specify-both-output-directory-and-backup-target
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2613"
reproduced: false
---

# `cannot specify both output directory and backup target`

## What it means

`pg_basebackup` was given both an output-directory option and a `--target` option. A backup target writes the backup on the server side, so a client-side output directory cannot also apply.

## When it happens

It happens when `--pgdata`/`-D` is combined with `--target` on the `pg_basebackup` command line.

## How to fix

Choose one destination. Use `--target` to write on the server, or `-D` to write to a local directory. Remove the option you do not need and rerun.

## Example

*Illustrative* — output directory and target both given.

```text
pg_basebackup: error: cannot specify both output directory and backup target
```

## Related

- [cannot specify both format and backup target](./cannot-specify-both-format-and-backup-target.md)
- [cannot stream write-ahead logs in tar mode to stdout](./cannot-stream-write-ahead-logs-in-tar-mode-to-stdout.md)
