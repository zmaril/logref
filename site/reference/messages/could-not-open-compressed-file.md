---
message: "could not open compressed file \"%s\": %m"
slug: could-not-open-compressed-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:340"
reproduced: false
---

# `could not open compressed file "%s": %m`

## What it means

`pg_receivewal` tried to open a compressed WAL file in its target directory and the operating system refused. The `%m` reason gives the cause. It opens existing compressed segments to resume or verify them.

## When it happens

It happens during a WAL receive when a compressed segment in the destination cannot be opened — usually a permissions problem, a missing file, or an I/O error on the destination.

## How to fix

Check the destination directory's permissions and storage health, and remove any damaged compressed segment left by an interrupted run, then rerun `pg_receivewal`.

## Example

*Illustrative* — a compressed segment could not be opened.

```text
pg_receivewal: fatal: could not open compressed file "000000010000000000000005.gz": Permission denied
```

## Related

- [could not read compressed file](./could-not-read-compressed-file.md)
- [could not open existing write-ahead log file](./could-not-open-existing-write-ahead-log-file.md)
