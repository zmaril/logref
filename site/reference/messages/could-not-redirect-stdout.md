---
message: "could not redirect stdout: %m"
slug: could-not-redirect-stdout
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/postmaster/syslogger.c:756"
reproduced: false
---

# `could not redirect stdout: %m`

## What it means

The logging collector process could not redirect its standard output to the log file. The trailing text is the operating-system error. The logging collector owns the server's log files when `logging_collector` is on.

## When it happens

It fires when the syslogger starts or reopens its output and cannot point standard output at the log destination — for example the log directory is missing or unwritable.

## How to fix

Check `log_directory` and its permissions: the directory must exist and be writable by the `postgres` OS user. Read the OS error for the specific cause, fix the directory or the disk-space condition, and let the collector reopen. A read-only or full filesystem under the log directory is a common trigger.

## Example

*Illustrative* — the collector could not redirect output.

```text
FATAL:  could not redirect stdout: No such file or directory
```

## Related

- [could not reopen file as stdout](./could-not-reopen-file-as-stdout.md)
- [could not write to log file](./could-not-write-to-log-file-8d5e1f.md)
