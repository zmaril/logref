---
message: "Please terminate the single-user server and try again.\n"
slug: please-terminate-the-single-user-server-and-try-again
passthrough: false
api: [write_stderr]
level: [varies]
call_sites:
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1109"
  - "postgres/src/bin/pg_ctl/pg_ctl.c:1167"
reproduced: false
---

# `Please terminate the single-user server and try again.
`

## What it means

A hint that an operation cannot proceed while a single-user-mode server is running, and that the single-user session must be ended first.

## When it happens

It accompanies an error from a tool that detected a running single-user backend (started with `postgres --single`) holding the data directory.

## Is this a problem?

End the single-user session (exit the `postgres --single` process) before retrying the operation. Single-user mode holds exclusive access to the data directory, which blocks the tool.

## Example

*Illustrative* — the single-user hint.

```text
HINT:  Please terminate the single-user server and try again.
```

## Related

- [The "-m fast" option immediately disconnects sessions rather than waiting for session-initiated disconnection.](./hint-the-m-fast-option-immediately-disconnects-sessions-rather-than-waiting-for.md)
- [could not start server: %m](./could-not-start-server.md)
