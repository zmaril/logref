---
message: "out of file descriptors: %m; release and retry"
slug: out-of-file-descriptors-release-and-retry
passthrough: false
api: [ereport]
level: [LOG]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_RESOURCES
    code: "53000"
call_sites:
  - "postgres/src/backend/storage/file/fd.c:1146"
  - "postgres/src/backend/storage/file/fd.c:2661"
  - "postgres/src/backend/storage/file/fd.c:2770"
  - "postgres/src/backend/storage/file/fd.c:2924"
reproduced: false
---

# `out of file descriptors: %m; release and retry`

## What it means

The server ran out of file descriptors it could open and is releasing some cached ones to retry. The placeholder is the OS error (typically `Too many open files`). Postgres maintains a pool of open files per backend and can shrink it under pressure; this LOG line records that it hit the OS limit and is recovering, not that an operation failed.

## When it happens

Many files open at once — high connection counts, many partitions or relations touched per backend, or a low OS `RLIMIT_NOFILE` — push the process against its descriptor limit. It is more common with large partitioned schemas or many concurrent backends.

## Is this a problem?

Usually the server recovers on its own and the message is informational. If it appears frequently, raise the OS open-file limit for the postgres user (`ulimit -n` / systemd `LimitNOFILE`) and review `max_files_per_process`. Reducing the number of relations touched per statement (fewer partitions scanned) also helps. Persistent pressure that degrades performance is the signal to act.

## Example

*Illustrative* — descriptor pressure logged by the server.

```text
LOG:  out of file descriptors: Too many open files; release and retry
```

## Related

- [could not open file](./could-not-open-file-c6e6a4.md)
- [out of memory](./out-of-memory-0fea34.md)
