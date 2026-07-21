---
message: "could not write blocks %u..%u in file \"%s\": %m"
slug: could-not-write-blocks-in-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:1138"
reproduced: false
---

# `could not write blocks %u..%u in file "%s": %m`

## What it means

The storage manager could not write a range of blocks to a relation file. The placeholders are the block range and the file, and the trailing text is the operating-system error. This is the multi-block write path used by asynchronous I/O.

## When it happens

It fires when the server flushes a run of dirty blocks to a data file and the write fails — most often a full disk or an I/O error on the storage.

## How to fix

Read the OS error. `No space left on device` means the filesystem holding the data directory is full; free space urgently, since the server cannot persist changes. An I/O error points at failing storage. Address the disk condition; until writes succeed, data is at risk of not being persisted.

## Example

*Illustrative* — a multi-block write failed.

```text
ERROR:  could not write blocks 100..107 in file "base/16384/24576": No space left on device
```

## Related

- [could not write block in file](./could-not-write-block-in-file.md)
- [could not start reading blocks in file](./could-not-start-reading-blocks-in-file.md)
