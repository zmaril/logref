---
message: "Command was: %s"
slug: command-was
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:942"
  - "postgres/src/bin/pg_dump/pg_dump.c:2471"
  - "postgres/src/bin/pg_dump/pg_dump.c:2481"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1205"
reproduced: false
---

# `Command was: %s`

## What it means

A detail line printed after a tool-level error, echoing the exact command (often a SQL statement) that failed. The placeholder is the command text. It accompanies a primary error to show what was being run when it failed.

## When it happens

A client tool (here `pg_amcheck`) reports a failure and attaches the failing command as detail so you can see and reproduce it.

## How to fix

Read the primary error line above this detail — that explains the failure. Use the echoed command to reproduce the problem directly and diagnose it. This line itself is context, not the error.

## Example

*Illustrative* — a detail line echoing the failed command.

```text
DETAIL:  Command was: SELECT * FROM verify_heapam('t');
```

## Related

- [could not execute command](./could-not-execute-command.md)
- [failed](./failed-6dc129.md)
