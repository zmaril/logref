---
message: "could not set timer: %m"
slug: could-not-set-timer
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:5975"
reproduced: false
---

# `could not set timer: %m`

## What it means

`psql` could not arm a timer it uses for the `\watch` command. The trailing text is the operating-system error. `\watch` reruns a query on an interval and relies on a timer to schedule the repeats.

## When it happens

It fires when you run `\watch` and `psql` cannot set up the interval timer, which is an unusual OS-level failure.

## How to fix

This points at an operating-system problem in the client environment rather than a mistake in your command. Try `\watch` again, and check for anything in the shell environment that interferes with timers. If it persists, capture the OS error for a report.

## Example

*Illustrative* — arming the watch timer failed.

```text
could not set timer: Invalid argument
```

## Related

- [could not wait for signals](./could-not-wait-for-signals.md)
- [could not set printing parameter](./could-not-set-printing-parameter.md)
