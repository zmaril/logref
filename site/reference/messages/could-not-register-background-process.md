---
message: "could not register background process"
slug: could-not-register-background-process
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_RESOURCES
    code: "53000"
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:941"
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:766"
reproduced: false
---

# `could not register background process`

## What it means

An extension could not register a dynamic background worker with the postmaster. The registration slots were full or the postmaster refused the request. The worker could not be started.

## When it happens

The number of background workers in use reached `max_worker_processes`, or an extension (for example `pg_prewarm` autoprewarm) tried to register a worker when no slot was free.

## How to fix

Raise `max_worker_processes` to leave room for the extension's workers (a restart is required), or reduce competing worker usage. Check which extensions and parallel queries consume worker slots.

## Example

*Illustrative* — no background-worker slot was available.

```text
ERROR:  could not register background process
HINT:  You may need to increase "max_worker_processes".
```

## Related

- [could not start background process](./could-not-start-background-process.md)
- [database connection requirement not indicated during registration](./database-connection-requirement-not-indicated-during-registration.md)
