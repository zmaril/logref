---
message: "could not read compressed file \"%s\": %m"
slug: could-not-read-compressed-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:349"
reproduced: false
---

# `could not read compressed file "%s": %m`

## What it means

`pg_receivewal` tried to read from a compressed WAL file in its target directory and the read failed. The `%m` reason gives the cause. It reads compressed segments to resume or verify them.

## When it happens

It happens during a WAL receive when a compressed segment cannot be read — usually a permissions problem, a truncated file, or an I/O error on the destination.

## How to fix

Check the destination directory's permissions and storage health, and remove any damaged compressed segment left by an interrupted run, then rerun `pg_receivewal`.

## Example

*Illustrative* — a compressed segment could not be read.

```text
pg_receivewal: fatal: could not read compressed file "000000010000000000000005.gz": Input/output error
```

## Related

- [could not read compressed file: read of](./could-not-read-compressed-file-read-of.md)
- [could not open compressed file](./could-not-open-compressed-file.md)
