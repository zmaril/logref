---
message: "%s: server does not shut down\n"
slug: server-does-not-shut-down
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1068"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1129"
reproduced: false
---

# `%s: server does not shut down
`

## What it means

A control tool waited for the server to stop and the server was still running when the wait timed out, so the shutdown did not complete in the allotted time.

## When it happens

It is printed by `pg_ctl stop` (and used by `pg_upgrade`) when the postmaster has not exited within the wait period — often because long-running transactions, a slow checkpoint, or stuck backends are holding shutdown up.

## Is this a problem?

Whether this is a problem depends on why shutdown stalled. Check the server log for what it is waiting on, look for active sessions or a heavy final checkpoint, and give it more time with a longer `--timeout`. Use `pg_ctl stop -m fast` for a prompt shutdown, and reserve `-m immediate` for emergencies since it forces recovery on the next start.

## Example

*Illustrative* — a shutdown that did not finish in time.

```text
pg_ctl: server does not shut down
```

## Related

- [terminated by user](./terminated-by-user.md)
- [a worker process died unexpectedly](./a-worker-process-died-unexpectedly.md)
