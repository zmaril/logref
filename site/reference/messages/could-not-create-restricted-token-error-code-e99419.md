---
message: "could not create restricted token: error code %lu"
slug: could-not-create-restricted-token-error-code-e99419
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/common/restricted_token.c:94"
reproduced: false
---

# `could not create restricted token: error code %lu`

## What it means

On Windows, a PostgreSQL program could not create the restricted access token it uses to drop administrator privileges before running. The `%lu` is the OS error code. Server-side programs refuse to run with full admin rights.

## When it happens

It happens on Windows when a tool started with elevated privileges tries to re-launch itself under a restricted token and the OS call fails.

## How to fix

This is a Windows OS-level failure. Run the program from an account that does not require the restricted-token step, or investigate the host's security policy. The error code identifies the specific Windows failure.

## Example

*Illustrative* — restricted-token creation failing on Windows.

```text
error: could not create restricted token: error code 1314
```

## Related

- [could not create signal event: error code](./could-not-create-signal-event-error-code.md)
- [could not create I/O completion port for child queue](./could-not-create-i-o-completion-port-for-child-queue.md)
