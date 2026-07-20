---
message: "getrlimit failed: %m"
slug: getrlimit-failed
passthrough: false
api: [ereport, pg_fatal]
level: [FATAL, WARNING]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:984"
  - "postgres/src/bin/pgbench/pgbench.c:6881"
reproduced: false
---

# `getrlimit failed: %m`

## What it means

A `getrlimit` system call failed while the server or `pgbench` queried a resource limit. The `%m` is the operating-system error. Severity is WARNING or FATAL by site.

## When it happens

The process could not read a resource limit (for example the open-file or stack limit) at startup — a rare platform or environment condition.

## How to fix

This is a low-level platform guard. Check the process's resource-limit environment. It is uncommon on a healthy host; if it recurs, capture the OS error and platform and report it.

## Example

*Illustrative* — getrlimit returned an error.

```text
WARNING:  getrlimit failed: Invalid argument
```

## Related

- [fcntl(F_SETFD) failed on socket](./fcntl-f-setfd-failed-on-socket.md)
- [exceeded maxAllocatedDescs while trying to open file](./exceeded-maxallocateddescs-while-trying-to-open-file.md)
