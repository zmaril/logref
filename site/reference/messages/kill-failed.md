---
message: "kill(%ld,%d) failed: %m"
slug: kill-failed
passthrough: false
api: [elog]
level: [DEBUG3]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:3500"
  - "postgres/src/backend/postmaster/postmaster.c:3510"
reproduced: false
---

# `kill(%ld,%d) failed: %m`

## What it means

A very-high-level debug trace line that a `kill` system call (used to signal another process) failed; the errno string gives the reason.

## When it happens

It appears at the highest debug levels when the server signals a process — for example to wake or cancel it — and the call fails, often because the target already exited.

## Is this a problem?

No action is needed in most cases; signalling a process that has already exited is benign and appears only under deep tracing. Investigate only if it accompanies a real inter-process coordination problem.

## Example

*Illustrative* — a failed kill trace line.

```text
DEBUG:  kill(12345,10) failed: No such process
```

## Related

- [key (%u, %u) -> %u](./key.md)
- [munmap(%p, %zu) failed: %m](./munmap-failed-7c74ce.md)
