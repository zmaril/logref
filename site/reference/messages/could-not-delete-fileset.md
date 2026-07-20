---
message: "could not delete fileset \"%s\": %m"
slug: could-not-delete-fileset
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/buffile.c:949"
reproduced: false
---

# `could not delete fileset "%s": %m`

## What it means

The server could not delete a shared fileset — a group of temporary files used by parallel query and similar features. The `%m` reason gives the OS error.

## When it happens

It happens when a shared fileset is torn down, for example at the end of a parallel operation, and removing its files fails from an I/O or permissions problem on the temporary filesystem.

## How to fix

Check the health and permissions of the filesystem holding temporary files (`temp_tablespaces` or the default `base/pgsql_tmp`). A transient failure needs no action; a persistent one points at a storage problem to fix.

## Example

*Illustrative* — a shared fileset that cannot be removed.

```text
ERROR:  could not delete fileset "...": Input/output error
```

## Related

- [could not delete unknown BufFile](./could-not-delete-unknown-buffile.md)
- [could not delete directory](./could-not-delete-directory.md)
