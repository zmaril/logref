---
message: "could not register process for wait: error code %lu"
slug: could-not-register-process-for-wait-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:4681"
reproduced: false
---

# `could not register process for wait: error code %lu`

## What it means

On Windows, the postmaster could not register a child process with the operating system's wait facility. The trailing text is the Windows error code. Registration is how the postmaster learns when a backend exits.

## When it happens

It fires when the postmaster spawns a child on Windows and the call that arranges to be notified of the child's exit fails, often under resource pressure or handle exhaustion.

## How to fix

This is an OS-level failure at process launch. Check whether the host is out of handles or under memory pressure, and look at the surrounding log for what the server was starting. If it recurs on a healthy host, capture the Windows error code and the log for a bug report.

## Example

*Illustrative* — child registration failed on Windows.

```text
FATAL:  could not register process for wait: error code 8
```

## Related

- [could not start process for command](./could-not-start-process-for-command-error-code.md)
- [could not reserve memory region](./could-not-reserve-memory-region-error-code.md)
