---
message: "backup targets are not supported by this server version"
slug: backup-targets-are-not-supported-by-this-server-version
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1938"
reproduced: false
---

# `backup targets are not supported by this server version`

## What it means

`pg_basebackup` asked the server to write the backup to a target other than the client, but the server is too old to understand backup targets. The target feature requires a newer server.

## When it happens

It occurs when a recent `pg_basebackup` uses `--target` against a server whose version predates server-side backup targets.

## How to fix

Either run without `--target` so the backup streams to the client, or connect to a server new enough to support backup targets. Backup targets let the server write to a location such as blackhole or a server-side path, and both ends must support the feature.

## Example

*Illustrative* — a target requested against an old server.

```text
FATAL:  backup targets are not supported by this server version
```

## Related

- [backup manifest version 1 does not support incremental backup](./backup-manifest-version-1-does-not-support-incremental-backup.md)
- [backup failed](./backup-failed.md)
