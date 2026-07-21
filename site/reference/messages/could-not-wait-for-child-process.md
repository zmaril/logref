---
message: "could not wait for child process: %m"
slug: could-not-wait-for-child-process
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2232"
reproduced: false
---

# `could not wait for child process: %m`

## What it means

`pg_basebackup` could not wait for its background child process. The trailing text is the operating-system error. The tool waits for its worker to finish before completing.

## When it happens

It fires as `pg_basebackup` finishes and tries to collect its background worker, when the wait call fails — an unusual OS-level condition around the child process.

## How to fix

Look earlier in the output for the child's own error; this message usually follows the worker exiting abnormally. Address whatever caused the worker to fail — a server disconnect or a disk problem on the target — and rerun the backup.

## Example

*Illustrative* — waiting for the child failed.

```text
pg_basebackup: error: could not wait for child process: No child processes
```

## Related

- [could not wait for child thread](./could-not-wait-for-child-thread.md)
- [could not read from ready pipe](./could-not-read-from-ready-pipe.md)
