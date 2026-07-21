---
message: "could not start process for command \"%s\": error code %lu"
slug: could-not-start-process-for-command-error-code
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/common/restricted_token.c:115"
reproduced: false
---

# `could not start process for command "%s": error code %lu`

## What it means

A tool running under a restricted access token on Windows could not start a child process for a command. The placeholder is the command and the trailing text is the Windows error code. Server programs drop privileges by launching under a restricted token.

## When it happens

It fires on Windows when a program such as `initdb`, `pg_ctl`, or a server tool creates a child process under a restricted token and the launch fails.

## How to fix

This is a Windows process-launch failure. It can be caused by security software blocking process creation or by a restricted service account lacking the needed rights. Check the Windows error code, review antivirus or policy restrictions on the account, and grant the account the ability to create processes.

## Example

*Illustrative* — launching a child under a restricted token failed.

```text
pg_ctl: error: could not start process for command "C:\\pg\\bin\\postgres.exe": error code 5
```

## Related

- [could not register process for wait](./could-not-register-process-for-wait-error-code.md)
- [could not reserve memory region](./could-not-reserve-memory-region-error-code.md)
