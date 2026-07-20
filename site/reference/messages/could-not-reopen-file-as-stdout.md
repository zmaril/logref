---
message: "could not reopen file \"%s\" as stdout: %m"
slug: could-not-reopen-file-as-stdout
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/error/elog.c:2344"
reproduced: false
---

# `could not reopen file "%s" as stdout: %m`

## What it means

The server could not reopen a file as its standard output stream. The placeholder is the file and the trailing text is the operating-system error. This is the standard-output counterpart of the stderr reopen failure.

## When it happens

It fires while logging is set up, when the file meant to receive standard output cannot be opened for writing.

## How to fix

Check that the log directory exists and is writable by the `postgres` OS user and that the filesystem is not full. Read the OS error, correct the underlying condition, and let logging reopen its output. This concerns the server's log infrastructure rather than any SQL statement.

## Example

*Illustrative* — reopening stdout onto a log file failed.

```text
FATAL:  could not reopen file "/var/log/postgresql/server.log" as stdout: No such file or directory
```

## Related

- [could not reopen file as stderr](./could-not-reopen-file-as-stderr.md)
- [could not redirect stdout](./could-not-redirect-stdout.md)
