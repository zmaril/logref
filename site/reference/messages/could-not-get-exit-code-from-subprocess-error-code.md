---
message: "could not get exit code from subprocess: error code %lu"
slug: could-not-get-exit-code-from-subprocess-error-code
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/common/restricted_token.c:168"
reproduced: false
---

# `could not get exit code from subprocess: error code %lu`

## What it means

On Windows, a Postgres program launched a child process under a restricted access token and could not read the child's exit code. The `%lu` value is the Windows error code. The parent needs the exit code to report whether the child succeeded.

## When it happens

It happens on Windows when a server-related program (which drops privileges by re-launching itself under a restricted token) cannot obtain the subprocess exit code via `GetExitCodeProcess` — an unusual operating-system-level failure.

## How to fix

This is a low-level Windows failure. Rerun the program; if it persists, check the host for resource pressure or instability, and confirm the service account has the rights to create and inspect processes. Look up the reported error code for the specific cause.

## Example

*Illustrative* — the child's exit code could not be read.

```text
FATAL:  could not get exit code from subprocess: error code 6
```

## Related

- [could not get child thread exit status](./could-not-get-child-thread-exit-status.md)
- [could not get token information error code](./could-not-get-token-information-error-code-c77e86.md)
