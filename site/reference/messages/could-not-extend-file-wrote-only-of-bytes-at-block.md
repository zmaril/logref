---
message: "could not extend file \"%s\": wrote only %d of %d bytes at block %u"
slug: could-not-extend-file-wrote-only-of-bytes-at-block
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DISK_FULL
    code: "53100"
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:531"
reproduced: false
---

# `could not extend file "%s": wrote only %d of %d bytes at block %u`

## What it means

The storage manager tried to grow a relation file by writing a new block and only part of the block was written. The `%s` names the file and the counts show how many bytes landed. A short write means the disk is out of space.

## When it happens

It happens when a relation extends during an insert, update, or index build and the write of the new page is truncated, essentially always because the filesystem is full.

## How to fix

Free space on the tablespace's filesystem, then retry. Persistent disk-full conditions call for adding storage, moving the relation to a tablespace with room, or removing unneeded data.

## Example

*Illustrative* — a short write extending a relation.

```text
ERROR:  could not extend file "base/16384/16400": wrote only 4096 of 8192 bytes at block 1234
```

## Related

- [could not extend file with FileFallocate()](./could-not-extend-file-with-filefallocate.md)
- [could not create archive status file](./could-not-create-archive-status-file-29a4bc.md)
