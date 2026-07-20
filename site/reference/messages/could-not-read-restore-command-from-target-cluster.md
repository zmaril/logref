---
message: "could not read \"restore_command\" from target cluster"
slug: could-not-read-restore-command-from-target-cluster
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1123"
reproduced: false
---

# `could not read "restore_command" from target cluster`

## What it means

`pg_rewind` could not read the `restore_command` setting from the cluster it is rewinding. It needs that setting to fetch WAL segments from the archive when they are missing from `pg_wal`.

## When it happens

It happens when you run `pg_rewind` with `--restore-target-wal` but the target cluster has no `restore_command` configured, or the query for it comes back empty.

## How to fix

Set `restore_command` in the target cluster's configuration so `pg_rewind` can retrieve archived WAL, or supply the missing segments another way. If you do not intend to use the archive, drop `--restore-target-wal` and make sure every WAL segment `pg_rewind` needs is present in `pg_wal`.

## Example

*Illustrative* — no restore_command to read.

```text
pg_rewind: error: could not read "restore_command" from target cluster
```

## Related

- [could not restore file from archive](./could-not-restore-file-from-archive-87edff.md)
- [could not read server file](./could-not-read-server-file.md)
