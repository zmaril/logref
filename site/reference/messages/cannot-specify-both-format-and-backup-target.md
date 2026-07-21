---
message: "cannot specify both format and backup target"
slug: cannot-specify-both-format-and-backup-target
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2595"
reproduced: false
---

# `cannot specify both format and backup target`

## What it means

`pg_basebackup` was given both an output-format option and a `--target` option. A backup target sends the backup to a server-side destination, which sets its own format, so an explicit `--format` cannot also apply.

## When it happens

It happens when `--format` (or `-F`) is combined with `--target` on the `pg_basebackup` command line.

## How to fix

Drop one of the two. Use `--target` for a server-side destination and let it own the format, or remove `--target` and keep `--format` for a client-side backup.

## Example

*Illustrative* — format and target both given.

```text
pg_basebackup: error: cannot specify both format and backup target
```

## Related

- [cannot specify both output directory and backup target](./cannot-specify-both-output-directory-and-backup-target.md)
- [cannot stream write-ahead logs in tar mode to stdout](./cannot-stream-write-ahead-logs-in-tar-mode-to-stdout.md)
