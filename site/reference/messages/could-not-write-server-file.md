---
message: "could not write server file \"%s\": %m"
slug: could-not-write-server-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/libpq/be-fsstubs.c:536"
reproduced: false
---

# `could not write server file "%s": %m`

## What it means

A server-side function that writes a file on the database host failed. This backs the large-object import path and similar server-file writers. The placeholder is the file and the trailing text is the operating-system error.

## When it happens

It fires when server code writes a named file on behalf of a query — for example `lo_import` reading a large object into place — and the write fails.

## How to fix

Read the OS error. `Permission denied` means the `postgres` OS user cannot write the file; `No space left on device` means the disk is full. These paths are on the database host, not the client. Fix the permission or space problem, or perform the operation from the client side where that is an option.

## Example

*Illustrative* — a server-side write failed.

```text
ERROR:  could not write server file "/var/lib/postgresql/import.dat": Permission denied
```

## Related

- [could not read server file](./could-not-read-server-file.md)
- [could not write to COPY file](./could-not-write-to-copy-file.md)
