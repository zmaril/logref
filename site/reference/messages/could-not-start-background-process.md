---
message: "could not start background process"
slug: could-not-start-background-process
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_RESOURCES
    code: "53000"
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:948"
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:772"
reproduced: false
---

# `could not start background process`

## What it means

An extension registered a background worker but the postmaster could not start it. Registration succeeded, but launching the process failed, so the worker did not run.

## When it happens

The postmaster could not fork the worker (a resource limit or `fork` failure), or the worker exited immediately during startup. It fires for extension workers such as `pg_prewarm` autoprewarm.

## How to fix

Check the server log for the worker's own startup error and for `fork`/resource messages. Ensure the host has capacity (memory, process limits) and that `max_worker_processes` is adequate, then retry.

## Example

*Illustrative* — the postmaster could not launch a worker.

```text
ERROR:  could not start background process
HINT:  More details may be available in the server log.
```

## Related

- [could not register background process](./could-not-register-background-process.md)
- [database connection requirement not indicated during registration](./database-connection-requirement-not-indicated-during-registration.md)
