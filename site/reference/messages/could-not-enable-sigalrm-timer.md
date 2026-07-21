---
message: "could not enable SIGALRM timer: %m"
slug: could-not-enable-sigalrm-timer
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/misc/timeout.c:347"
reproduced: false
---

# `could not enable SIGALRM timer: %m`

## What it means

The server could not arm the `SIGALRM`-based interval timer it uses for timeouts such as statement and lock timeouts. The `%m` reason gives the OS error. This is a low-level timer setup step.

## When it happens

It fires when the timeout subsystem tries to program the OS timer and the call fails. In practice this points at an OS-level problem rather than anything in the query.

## How to fix

This is an OS-level failure in the timer facility. Check the system log for kernel or resource problems around the time it appears. If it recurs on a healthy host, report a reproducible case.

## Example

*Illustrative* — the interval timer failing to arm.

```text
FATAL:  could not enable SIGALRM timer: Invalid argument
```

## Related

- [could not create timer event: error code](./could-not-create-timer-event-error-code.md)
- [could not create timer thread: error code](./could-not-create-timer-thread-error-code.md)
