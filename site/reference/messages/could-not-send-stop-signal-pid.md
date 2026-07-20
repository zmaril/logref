---
message: "%s: could not send stop signal (PID: %d): %m\n"
slug: could-not-send-stop-signal-pid
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:863"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1051"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1118"
reproduced: false
---

# `%s: could not send stop signal (PID: %d): %m
`

## What it means

The pg_ctl control tool could not send a stop signal to the server's main process. It reports the process identifier and the operating-system error. The stop request did not reach the server.

## When it happens

Running `pg_ctl stop` when the recorded process could not be signalled — the server already stopped, a stale postmaster PID file, or a permission problem sending the signal.

## Is this a problem?

Read the system error detail. If the server already stopped, the PID file may be stale; confirm no server is running and remove a leftover `postmaster.pid` if appropriate. If it is a permission problem, run pg_ctl as the account that owns the server process.

## Example

*Illustrative* — a failed stop signal.

```text
pg_ctl: could not send stop signal (PID: 12345): No such process
```

## Related

- [could not send signal to process](./could-not-send-signal-to-process.md)
- [you must run as the postgresql superuser](./you-must-run-as-the-postgresql-superuser.md)
