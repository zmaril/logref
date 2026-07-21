---
message: "backslash commands are restricted; only \\unrestrict is allowed"
slug: backslash-commands-are-restricted-only-unrestrict-is-allowed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:254"
reproduced: false
---

# `backslash commands are restricted; only \unrestrict is allowed`

## What it means

A `psql` session is in restricted mode, where backslash meta-commands are blocked, and a backslash command other than the one that lifts the restriction was entered. Only the unrestrict command is permitted until the restriction is cleared.

## When it happens

It occurs in `psql` after restricted mode has been entered, typically to run a script safely, when a script or interactive line uses a disallowed backslash command.

## How to fix

Lift the restriction with the permitted unrestrict command before using other backslash commands, or remove the backslash commands from the restricted section. Restricted mode exists to run untrusted SQL without exposing client-side meta-commands.

## Example

*Illustrative* — a blocked meta-command in restricted mode.

```text
ERROR:  backslash commands are restricted; only \unrestrict is allowed
```

## Related

- [backup is not in progress](./backup-is-not-in-progress.md)
- [autoprewarm is disabled](./autoprewarm-is-disabled.md)
