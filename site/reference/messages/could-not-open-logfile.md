---
message: "could not open logfile \"%s\": %m"
slug: could-not-open-logfile
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7559"
reproduced: false
---

# `could not open logfile "%s": %m`

## What it means

`pgbench` tried to open a per-thread log file to record transaction timings and the operating system refused. The `%m` reason gives the cause. The `--log` option makes each client thread write a log file.

## When it happens

It happens when starting `pgbench` with logging enabled, when a log file cannot be created — usually the working directory is not writable, or a log-file-prefix path points at a directory that does not exist.

## How to fix

Run `pgbench` from a writable directory, or set `--log-prefix` to a path whose directory exists and is writable. Creating the directory or fixing its permissions resolves it.

## Example

*Illustrative* — a pgbench log file could not be created.

```text
pgbench: fatal: could not open logfile "pgbench_log.1234": Permission denied
```

## Related

- [could not locate temporary directory](./could-not-locate-temporary-directory.md)
- [could not open version file](./could-not-open-version-file.md)
