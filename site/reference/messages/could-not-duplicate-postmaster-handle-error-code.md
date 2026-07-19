---
message: "could not duplicate postmaster handle: error code %lu"
slug: could-not-duplicate-postmaster-handle-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/postmaster.c:4738"
reproduced: false
---

# `could not duplicate postmaster handle: error code %lu`

## What it means

On Windows, the postmaster could not duplicate its own process handle so a child backend could inherit it. The `%lu` is the OS error code. The child needs this handle to detect postmaster death.

## When it happens

It happens on Windows during backend startup when `DuplicateHandle` for the postmaster handle fails, usually from OS-level resource exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for handle exhaustion, resolve the pressure, and restart the server.

## Example

*Illustrative* — postmaster handle duplication failing.

```text
FATAL:  could not duplicate postmaster handle: error code 8
```

## Related

- [could not create signal event: error code](./could-not-create-signal-event-error-code.md)
- [could not create I/O completion port for child queue](./could-not-create-i-o-completion-port-for-child-queue.md)
