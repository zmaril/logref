---
message: "autoprewarm worker is already running under PID %d"
slug: autoprewarm-worker-is-already-running-under-pid
passthrough: false
api: [ereport]
level: [ERROR, LOG]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:201"
  - "postgres/contrib/pg_prewarm/autoprewarm.c:839"
reproduced: false
---

# `autoprewarm worker is already running under PID %d`

## What it means

A request to start the pg_prewarm autoprewarm worker found one already running. Only a single autoprewarm worker runs at a time, and its process identifier is reported. Depending on the path it is raised as an error or logged.

## When it happens

Calling the function that launches the autoprewarm worker while the background worker is already active, or a second launch attempt racing with the running one.

## How to fix

No second worker is needed; the existing one is already doing the work. If you intended to restart it, stop the running worker first, then start a new one. The message reports the active worker's process identifier if you need to inspect it.

## Example

*Illustrative* — starting an already-running autoprewarm worker.

```text
ERROR:  autoprewarm worker is already running under PID 12345
```

## Related

- [could not open shared memory segment](./could-not-open-shared-memory-segment.md)
- [bad buffer id](./bad-buffer-id.md)
