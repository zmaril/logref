---
message: "registering background worker \"%s\""
slug: registering-background-worker
passthrough: false
api: [ereport]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/postmaster/bgworker.c:436"
  - "postgres/src/backend/postmaster/bgworker.c:1001"
reproduced: false
---

# `registering background worker "%s"`

## What it means

The postmaster is recording a background worker that a loaded module asked it to run, so that worker can be started at the appropriate time.

## When it happens

It is logged at DEBUG1 during startup when an extension listed in `shared_preload_libraries` (or a running backend) registers a background worker with the server.

## Is this a problem?

This is startup tracing that confirms a module's worker was registered. No action is needed. If a worker you expect never starts, check that its library is in `shared_preload_libraries` and that registration is happening at the right time.

## Example

*Illustrative* — a preloaded extension registering its worker.

```text
DEBUG:  registering background worker "my_extension worker"
```

## Related

- [a worker process died unexpectedly](./a-worker-process-died-unexpectedly.md)
- [all replication slots are in use](./all-replication-slots-are-in-use.md)
