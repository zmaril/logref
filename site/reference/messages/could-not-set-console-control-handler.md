---
message: "could not set console control handler"
slug: could-not-set-console-control-handler
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32/signal.c:110"
reproduced: false
---

# `could not set console control handler`

## What it means

On Windows, the server could not install its console control handler. That handler lets the process respond to console signals such as Ctrl+C and shutdown events.

## When it happens

It fires during startup on Windows when the call to register the control handler with the operating system fails.

## How to fix

This is a Windows OS-level failure at startup and is not caused by any database activity. It usually indicates an unusual process environment or an OS problem. Capture the surrounding log and, if it persists on a healthy host, report it with the Windows details.

## Example

*Illustrative* — the console handler could not be set.

```text
FATAL:  could not set console control handler
```

## Related

- [could not register process for wait](./could-not-register-process-for-wait-error-code.md)
- [could not reserve memory region](./could-not-reserve-memory-region-error-code.md)
