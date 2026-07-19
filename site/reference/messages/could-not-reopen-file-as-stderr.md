---
message: "could not reopen file \"%s\" as stderr: %m"
slug: could-not-reopen-file-as-stderr
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/error/elog.c:2331"
reproduced: false
---

# `could not reopen file "%s" as stderr: %m`

## What it means

The server could not reopen a file as its standard error stream. The placeholder is the file and the trailing text is the operating-system error. This runs when the log destination is redirected onto standard error.

## When it happens

It fires while the error-logging machinery sets up its output, when the target file for standard error cannot be opened — a missing directory, a permission problem, or a full disk.

## How to fix

Check the log directory named in the error: it must exist and be writable by the `postgres` OS user, with room on the filesystem. Read the OS error for the exact cause, fix it, and let logging reopen. This is an infrastructure problem, not a query problem.

## Example

*Illustrative* — reopening stderr onto a log file failed.

```text
FATAL:  could not reopen file "/var/log/postgresql/server.log" as stderr: Permission denied
```

## Related

- [could not reopen file as stdout](./could-not-reopen-file-as-stdout.md)
- [could not redirect stdout](./could-not-redirect-stdout.md)
