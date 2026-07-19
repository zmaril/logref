---
message: "exceeded maxAllocatedDescs (%d) while trying to open directory \"%s\""
slug: exceeded-maxallocateddescs-while-trying-to-open-directory
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_RESOURCES
    code: "53000"
call_sites:
  - "postgres/src/backend/storage/file/fd.c:2900"
reproduced: false
---

# `exceeded maxAllocatedDescs (%d) while trying to open directory "%s"`

## What it means

A backend hit its internal limit on tracked file descriptors while opening a directory. The placeholders are the limit and the directory path. The cap guards against descriptor leaks.

## When it happens

It fires when a function that opens directories (such as `pg_ls_dir` and its relatives, or an extension that walks the filesystem) is called while the backend already holds the maximum number of allocated descriptors.

## How to fix

Find the session opening many directories or files without releasing them and reduce how many are open at once. If an extension or a tight loop over directory-listing functions leaks handles, fix or report that. The limit is internal and not user-tunable.

## Example

*Illustrative* — the message as logged.

```
ERROR:  exceeded maxAllocatedDescs (32) while trying to open directory "/var/lib/postgresql/data/log"
```

## Related

- [exceeded maxAllocatedDescs while trying to execute command](./exceeded-maxallocateddescs-while-trying-to-execute-command.md)
- [failed NUMA pages inquiry](./failed-numa-pages-inquiry.md)
