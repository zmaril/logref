---
message: "could not read from COPY file: %m"
slug: could-not-read-from-copy-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:260"
reproduced: false
---

# `could not read from COPY file: %m`

## What it means

A `COPY ... FROM` reading from a server-side file (or program) could not read its input. The `%m` reason gives the cause. `COPY FROM` streams rows out of the named source.

## When it happens

It happens during `COPY table FROM 'file'` (or `FROM PROGRAM`) when the server-side source cannot be read — usually a permissions or I/O problem on the file, or a program that failed, all evaluated as the server's operating-system user.

## How to fix

Confirm the source file is readable by the server's operating-system account (not the client's), or that the `PROGRAM` runs successfully. For client-side files use `psql`'s `\copy` instead, which reads as the client user.

## Example

*Illustrative* — the COPY source could not be read.

```text
ERROR:  could not read from COPY file: Input/output error
```

## Related

- [could not open server file](./could-not-open-server-file.md)
- [could not read from file at offset](./could-not-read-from-file-at-offset.md)
