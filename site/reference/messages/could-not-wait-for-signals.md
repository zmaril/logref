---
message: "could not wait for signals: %m"
slug: could-not-wait-for-signals
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:6111"
reproduced: false
---

# `could not wait for signals: %m`

## What it means

`psql` could not wait for signals while running the `\watch` command. The trailing text is the operating-system error. `\watch` waits between reruns and needs to notice interruptions such as Ctrl+C.

## When it happens

It fires during a `\watch` loop when the client cannot set up or perform its wait for signals, which is an unusual OS-level failure in the client environment.

## How to fix

This points at an operating-system problem in the environment running `psql` rather than a mistake in your query. Try the command again, and check for anything in the shell environment interfering with signal handling. Capture the OS error if it recurs.

## Example

*Illustrative* — waiting for signals failed during \watch.

```text
could not wait for signals: Invalid argument
```

## Related

- [could not set timer](./could-not-set-timer.md)
- [could not set printing parameter](./could-not-set-printing-parameter.md)
