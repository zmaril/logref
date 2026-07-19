---
message: "terminated by user\n"
slug: terminated-by-user
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:597"
  - "postgres/src/bin/pg_dump/parallel.c:695"
reproduced: false
---

# `terminated by user
`

## What it means

An operation stopped because the user interrupted it — typically by pressing Ctrl-C or sending a cancel — rather than because of an internal fault.

## When it happens

It is reported by client tools and utilities when a running command receives a user-initiated interrupt and unwinds.

## Is this a problem?

Whether this matters depends on intent: if you cancelled the operation, it did what you asked. If it stopped unexpectedly, check whether a signal was delivered by a supervising process, a timeout wrapper, or a shell that forwarded an interrupt.

## Example

*Illustrative* — a utility cancelled from the keyboard.

```text
pg_basebackup: terminated by user
```

## Related

- [server does not shut down](./server-does-not-shut-down.md)
- [a worker process died unexpectedly](./a-worker-process-died-unexpectedly.md)
