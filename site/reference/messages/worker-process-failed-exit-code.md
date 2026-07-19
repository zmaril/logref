---
message: "worker process failed: exit code %d"
slug: worker-process-failed-exit-code
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2577"
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:4863"
reproduced: false
---

# `worker process failed: exit code %d`

## What it means

A background worker process exited with a non-zero status, and the postmaster is reporting the exit code it observed.

## When it happens

It arises when a background worker — a built-in one, a parallel worker, or one registered by an extension — terminates abnormally rather than shutting down cleanly.

## How to fix

Look for the worker's own error just before this line; it explains why the worker died. Investigate the extension or feature that registered the worker, and check for crashes, out-of-memory, or a failed initialization.

## Example

*Illustrative* — a background worker exiting non-zero.

```text
FATAL:  worker process failed: exit code 1
```

## Related

- [unknown worker type](./unknown-worker-type-319e82.md)
- [Unknown worker type](./unknown-worker-type-40c67f.md)
