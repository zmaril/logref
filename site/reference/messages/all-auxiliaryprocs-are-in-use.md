---
message: "all AuxiliaryProcs are in use"
slug: all-auxiliaryprocs-are-in-use
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/storage/lmgr/proc.c:664"
reproduced: false
---

# `all AuxiliaryProcs are in use`

## What it means

The server needed to start an auxiliary process (such as a background writer helper, WAL process, or similar internal role) but every slot reserved for auxiliary processes was already occupied.

## When it happens

It is raised as fatal when the fixed pool of auxiliary process slots is exhausted, which normally should not happen and can indicate leaked or stuck auxiliary processes.

## How to fix

This points at an internal resource being exhausted rather than a user setting. Check for stuck or crashed auxiliary processes in the server log and process list, and consider a server restart to clear them. If it recurs, capture the log and report it; there is no user-facing parameter that expands this fixed pool.

## Example

*Illustrative* — the auxiliary process slots exhausted.

```text
FATAL:  all AuxiliaryProcs are in use
```

## Related

- [a worker process died unexpectedly](./a-worker-process-died-unexpectedly.md)
- [all replication slots are in use](./all-replication-slots-are-in-use.md)
