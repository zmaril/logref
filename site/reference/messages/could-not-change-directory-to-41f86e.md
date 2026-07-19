---
message: "\\%s: could not change directory to \"%s\": %m"
slug: could-not-change-directory-to-41f86e
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:738"
reproduced: false
---

# `\%s: could not change directory to "%s": %m`

## What it means

A psql meta-command (such as `\cd`) could not change the working directory to the requested path. The `%m` reason gives the OS error. The directory was not changed.

## When it happens

It happens in psql when `\cd dir` names a path that does not exist, is not a directory, or is not accessible to the user.

## How to fix

Use a valid, accessible directory path. Check that the directory exists and you have permission to enter it; correct the path and retry.

## Example

*Illustrative* — a failed \cd in psql.

```text
\cd: could not change directory to "/nope": No such file or directory
```

## Related

- [\connect](./connect.md)
- [connection to server was lost](./connection-to-server-was-lost.md)
