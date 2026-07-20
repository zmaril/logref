---
message: "could not create worker thread: %m"
slug: could-not-create-worker-thread
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:976"
  - "postgres/src/bin/pg_upgrade/parallel.c:144"
  - "postgres/src/bin/pg_upgrade/parallel.c:255"
reproduced: false
---

# `could not create worker thread: %m`

## What it means

On Windows, a parallel-capable tool (here `pg_dump`) could not create a worker thread. The placeholder is the OS error. The Windows build uses threads rather than forked processes for parallel work; a failure to create one prevents the requested parallelism.

## When it happens

Thread or memory resource limits reached on the host, or an OS-level failure to start the thread — more likely with a high `--jobs` count on a constrained machine.

## How to fix

Read the appended OS error. Reduce `--jobs`, free memory/resources, or raise the host's limits, then re-run. If the machine cannot support the parallelism you asked for, use fewer workers.

## Example

*Illustrative* — parallel dump failing to start a thread on Windows.

```text
pg_dump: error: could not create worker thread: Not enough memory resources
```

## Related

- [could not create worker process](./could-not-create-worker-process.md)
- [out of memory](./out-of-memory-0fea34.md)
