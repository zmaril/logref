---
message: "HINT: The \"-m fast\" option immediately disconnects sessions rather than\nwaiting for session-initiated disconnection.\n"
slug: hint-the-m-fast-option-immediately-disconnects-sessions-rather-than-waiting-for
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1070"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1131"
reproduced: false
---

# `HINT: The "-m fast" option immediately disconnects sessions rather than
waiting for session-initiated disconnection.
`

## What it means

A hint from a shutdown tool explaining that the `-m fast` option disconnects sessions immediately instead of waiting for them to end on their own.

## When it happens

It accompanies a message about a slow smart shutdown, suggesting fast mode when sessions are keeping the server from stopping.

## Is this a problem?

No action is needed on the hint itself. If a shutdown is stalling on active sessions, use `pg_ctl stop -m fast` to disconnect them and shut down promptly; smart mode waits for sessions to finish.

## Example

*Illustrative* — the fast-shutdown hint.

```text
HINT:  The "-m fast" option immediately disconnects sessions rather than
waiting for session-initiated disconnection.
```

## Related

- [please terminate the single-user server and try again](./please-terminate-the-single-user-server-and-try-again.md)
- [received interrupt signal, exiting](./received-interrupt-signal-exiting.md)
