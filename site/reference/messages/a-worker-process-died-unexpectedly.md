---
message: "a worker process died unexpectedly"
slug: a-worker-process-died-unexpectedly
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:1410"
reproduced: false
---

# `a worker process died unexpectedly`

## What it means

A background or parallel worker process the server started exited abnormally, without the orderly shutdown its parent expected, so the operation depending on it cannot continue.

## When it happens

It is reported as fatal when a worker crashes, is killed by the operating system (for example the OOM killer), or exits with an error the parent treats as a hard failure.

## How to fix

Look in the server log for the worker's own error just before this line — it names the real cause (out of memory, a crash in an extension, a signal). Address that root cause: reduce memory pressure, update or remove a faulty extension, or investigate the signal source. The parent session typically aborts and can be retried once the cause is fixed.

## Example

*Illustrative* — a worker exiting abnormally.

```text
FATAL:  a worker process died unexpectedly
```

## Related

- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
- [server does not shut down](./server-does-not-shut-down.md)
