---
message: "could not seek to end of file \"%s\": %m"
slug: could-not-seek-to-end-of-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/walsender.c:656"
  - "postgres/src/backend/storage/smgr/md.c:1892"
reproduced: false
---

# `could not seek to end of file "%s": %m`

## What it means

A seek to the end of a file failed. The `%s` is the path and the `%m` is the operating-system error. The server could not determine or move to the file's end — for example while a walsender read WAL or storage extended a relation.

## When it happens

An I/O error or an unexpected file state caused the seek to fail while the server needed the file's length or its tail.

## How to fix

Read the trailing error and check the file and its storage for faults. If the file is a relation or WAL segment that is damaged or truncated, investigate the device and restore from backup as needed.

## Example

*Illustrative* — seeking to end of a WAL file failed.

```text
ERROR:  could not seek to end of file "pg_wal/000000010000000000000005": Input/output error
```

## Related

- [could not seek in file](./could-not-seek-in-file.md)
- [could not read blocks in file](./could-not-read-blocks-in-file.md)
