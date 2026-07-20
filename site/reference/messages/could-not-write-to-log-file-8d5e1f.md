---
message: "could not write to log file \"%s\": %m"
slug: could-not-write-to-log-file-8d5e1f
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:349"
reproduced: false
---

# `could not write to log file "%s": %m`

## What it means

`pg_upgrade` could not write to one of its log files. The placeholder is the file and the trailing text is the operating-system error. `pg_upgrade` records its work in log files under the current directory.

## When it happens

It fires during an upgrade when a write to one of the tool's log files fails — a full disk, a permission problem, or an I/O error where the logs are being written.

## How to fix

Read the OS error. Make sure the directory `pg_upgrade` is run from is writable and has free space, since it creates log and dump files there. Fix the reported condition and rerun from a clean working directory.

## Example

*Illustrative* — a pg_upgrade log write failed.

```text
pg_upgrade: error: could not write to log file "pg_upgrade_server.log": No space left on device
```

## Related

- [could not read line from file](./could-not-read-line-from-file.md)
- [could not write to log file at offset, length](./could-not-write-to-log-file-at-offset-length.md)
