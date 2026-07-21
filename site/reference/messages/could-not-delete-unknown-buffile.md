---
message: "could not delete unknown BufFile \"%s\""
slug: could-not-delete-unknown-buffile
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/buffile.c:388"
reproduced: false
---

# `could not delete unknown BufFile "%s"`

## What it means

The server tried to delete a named BufFile from a shared fileset but no file of that name was registered. This is an internal consistency check in the shared-file-set code.

## When it happens

It fires when a shared BufFile is dropped by a name the fileset does not know about. It is not normally reachable through ordinary SQL and points at an internal bookkeeping problem.

## How to fix

This is an internal error. If it appears, note the operation that triggered it (often a parallel query or a hash-join spill) and report a reproducible case. There is no user-facing configuration to change.

## Example

*Illustrative* — a delete for a name the fileset does not hold.

```text
ERROR:  could not delete unknown BufFile "i1of2.p0.0"
```

## Related

- [could not delete fileset](./could-not-delete-fileset.md)
- [could not determine data type of concat() input](./could-not-determine-data-type-of-concat-input.md)
