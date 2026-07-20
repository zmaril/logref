---
message: "received interrupt signal, exiting"
slug: received-interrupt-signal-exiting
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:224"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:1109"
reproduced: false
---

# `received interrupt signal, exiting`

## What it means

An informational message that a tool received an interrupt signal (for example from Ctrl-C) and is exiting in response.

## When it happens

It arises in command-line tools when the operator interrupts them, so they report the signal and shut down.

## Is this a problem?

No action is needed if you interrupted the tool intentionally. If the interrupt was unexpected, investigate what sent the signal (a job scheduler, a timeout wrapper, or a terminal action).

## Example

*Illustrative* — exiting on an interrupt.

```text
INFO:  received interrupt signal, exiting
```

## Related

- [disconnected; waiting %d seconds to try again](./disconnected-waiting-seconds-to-try-again.md)
- [done](./done.md)
