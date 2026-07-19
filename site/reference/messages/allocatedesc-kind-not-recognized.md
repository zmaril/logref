---
message: "AllocateDesc kind not recognized"
slug: allocatedesc-kind-not-recognized
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:2808"
reproduced: false
---

# `AllocateDesc kind not recognized`

## What it means

The internal file-descriptor tracking code encountered an allocation-descriptor of a kind it does not know how to handle, an internal consistency guard over the server's open-resource bookkeeping.

## When it happens

It is raised if the structure that tracks open files, directories, and similar resources holds an entry with an unexpected kind tag, normally only reachable through memory corruption or a code bug.

## How to fix

This is an internal error, not a user-facing condition. If it appears, capture the log around it and any extensions in use and report it. There is no SQL-level workaround.

## Example

*Illustrative* — an unrecognized allocation-descriptor kind.

```text
ERROR:  AllocateDesc kind not recognized
```

## Related

- [allParameterTypes is not a 1-D Oid array](./allparametertypes-is-not-a-1-d-oid-array.md)
- [attempt to write bogus relation mapping](./attempt-to-write-bogus-relation-mapping.md)
