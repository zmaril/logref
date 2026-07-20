---
message: "exceeded maxAllocatedDescs (%d) while trying to execute command \"%s\""
slug: exceeded-maxallocateddescs-while-trying-to-execute-command
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_RESOURCES
    code: "53000"
call_sites:
  - "postgres/src/backend/storage/file/fd.c:2741"
reproduced: false
---

# `exceeded maxAllocatedDescs (%d) while trying to execute command "%s"`

## What it means

A backend hit its internal limit on tracked file descriptors while launching an external command through a pipe. The placeholders are the limit and the command. This cap protects the server from leaking descriptors, so hitting it means too many are open at once.

## When it happens

It fires when a function or utility that opens pipes or files (for example `COPY ... PROGRAM`, some `pg_ls_*` functions, or an extension) tries to run a command while the backend already holds the maximum number of allocated descriptors.

## How to fix

Look for a session that opens many pipes or files without closing them — a loop over `COPY ... PROGRAM`, a directory-listing function, or an extension leaking handles. Close or batch the work so fewer descriptors are open simultaneously. If a specific extension leaks descriptors, that is a bug to report to its author.

## Example

*Illustrative* — the message as logged.

```
ERROR:  exceeded maxAllocatedDescs (32) while trying to execute command "gzip"
```

## Related

- [exceeded maxAllocatedDescs while trying to open directory](./exceeded-maxallocateddescs-while-trying-to-open-directory.md)
- [\!: failed](./failed-380ac7.md)
