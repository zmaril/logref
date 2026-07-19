---
message: "could not write to the communication channel: %m"
slug: could-not-write-to-the-communication-channel
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:1532"
  - "postgres/src/bin/pg_dump/parallel.c:1650"
reproduced: false
---

# `could not write to the communication channel: %m`

## What it means

A parallel `pg_dump`/`pg_restore` worker could not write to the channel it uses to talk to the leader. The `%m` is the operating-system error. Coordination between the leader and worker broke.

## When it happens

A worker process died, a pipe or socket between processes broke, or an I/O error occurred, during a parallel dump or restore (`--jobs`).

## How to fix

Look for a worker that crashed or was killed, and for resource limits on pipes and processes. Reduce `--jobs` if the host is constrained, and rerun. The trailing error names the channel fault.

## Example

*Illustrative* — the worker-to-leader channel broke.

```text
pg_dump: error: could not write to the communication channel: Broken pipe
```

## Related

- [could not write to file](./could-not-write-to-file-ecc639.md)
- [disconnected](./disconnected.md)
