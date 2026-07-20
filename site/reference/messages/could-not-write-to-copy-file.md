---
message: "could not write to COPY file: %m"
slug: could-not-write-to-copy-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/copyto.c:639"
reproduced: false
---

# `could not write to COPY file: %m`

## What it means

`COPY TO` a file could not write to its destination. The trailing text is the operating-system error. This is the server-side file target of `COPY ... TO 'file'`.

## When it happens

It fires during a server-side `COPY TO` writing to a file on the database host, when the write fails — a full disk, a permission problem, or an I/O error on the server's storage.

## How to fix

Read the OS error. `No space left on device` means the server filesystem is full; `Permission denied` means the `postgres` OS user cannot write the path. Remember the path is on the server, not the client. Use `\copy` in `psql` to write on the client side instead, or fix the server-side path and space.

## Example

*Illustrative* — a server-side COPY TO ran out of space.

```text
ERROR:  could not write to COPY file: No space left on device
```

## Related

- [could not write to COPY program](./could-not-write-to-copy-program.md)
- [could not write server file](./could-not-write-server-file.md)
