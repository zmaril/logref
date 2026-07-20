---
message: "could not redirect stderr: %m"
slug: could-not-redirect-stderr
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/syslogger.c:761"
  - "postgres/src/backend/postmaster/syslogger.c:778"
reproduced: false
---

# `could not redirect stderr: %m`

## What it means

The logging collector (syslogger) could not redirect the server's standard error into its log pipe at startup. The `%m` is the operating-system error. Without the redirect the collector cannot capture server output.

## When it happens

A descriptor or pipe operation failed while the syslogger set up during postmaster startup — a resource limit or an unusual environment.

## How to fix

Check descriptor limits and the postmaster's startup environment. This is rare on a normal install; if it recurs, capture the startup logs and the platform, and report it.

## Example

*Illustrative* — stderr redirection failed at startup.

```text
FATAL:  could not redirect stderr: Bad file descriptor
```

## Related

- [could not load](./could-not-load-078321.md)
- [getrlimit failed](./getrlimit-failed.md)
