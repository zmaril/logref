---
message: "could not read server file \"%s\": %m"
slug: could-not-read-server-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/be-fsstubs.c:465"
reproduced: false
---

# `could not read server file "%s": %m`

## What it means

A server-side function that reads a file on the database host failed. This backs the large-object export path and similar server-file readers. The placeholder is the file and the trailing text is the operating-system error.

## When it happens

It fires when server code reads a named file on behalf of a query — for example `lo_export` writing a large object, or a function reading a server file — and the read fails.

## How to fix

Read the OS error. `Permission denied` means the `postgres` OS user cannot read the file; `No such file or directory` means the path is wrong from the server's point of view — these paths are on the database host, not the client. Fix the path or the file's permissions, or run the operation from the client side where that is an option.

## Example

*Illustrative* — a server-side read failed.

```text
ERROR:  could not read server file "/var/lib/postgresql/export.dat": Permission denied
```

## Related

- [could not write server file](./could-not-write-server-file.md)
- [could not read input file](./could-not-read-input-file.md)
