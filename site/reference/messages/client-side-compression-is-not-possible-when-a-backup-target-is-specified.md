---
message: "client-side compression is not possible when a backup target is specified"
slug: client-side-compression-is-not-possible-when-a-backup-target-is-specified
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2665"
reproduced: false
---

# `client-side compression is not possible when a backup target is specified`

## What it means

`pg_basebackup` was asked to compress on the client while also writing to a server-side backup target. A backup target keeps the data on the server, so there is no client-side stream to compress, and the combination is rejected.

## When it happens

It occurs with `pg_basebackup --compress=client-...` combined with `--target`.

## How to fix

Use server-side compression with a backup target, for example `--compress=server-gzip`, or drop `--target` to compress a client-side backup. Match the compression side to where the backup is written.

## Example

*Illustrative* — client compression with a target.

```text
pg_basebackup: error: client-side compression is not possible when a backup target is specified
```

## Related

- [cannot specify both format and backup target](./cannot-specify-both-format-and-backup-target.md)
- [cannot specify both output directory and backup target](./cannot-specify-both-output-directory-and-backup-target.md)
