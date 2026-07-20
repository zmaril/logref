---
message: "could not get current working directory: %m"
slug: could-not-get-current-working-directory
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/port/path.c:868"
reproduced: false
---

# `could not get current working directory: %m`

## What it means

Path-handling code asked the operating system for the process's current working directory and the call failed. The `%m` reason gives the cause. Some path calculations resolve relative names against the working directory.

## When it happens

It fires when `getcwd` fails — usually because the directory the process was started in has been removed or its permissions changed while the process is running.

## How to fix

Start the server or tool from a directory that exists and stays readable for the life of the process, and avoid deleting or unmounting the working directory out from under a running server. Restarting from a stable directory clears it.

## Example

*Illustrative* — the working directory could not be read.

```text
ERROR:  could not get current working directory: No such file or directory
```

## Related

- [could not get home directory for user id](./could-not-get-home-directory-for-user-id.md)
- [could not get junction for](./could-not-get-junction-for.md)
