---
message: "could not extend file \"%s\" with FileFallocate(): %m"
slug: could-not-extend-file-with-filefallocate
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:625"
reproduced: false
---

# `could not extend file "%s" with FileFallocate(): %m`

## What it means

The storage manager could not grow a relation file using `posix_fallocate` (via `FileFallocate`). The `%s` names the file and `%m` gives the OS error. The preallocation of new blocks failed.

## When it happens

It happens when a relation needs to extend — an insert or update adding pages — and the fast fallocate path fails, usually from a full filesystem or one that does not support fallocate.

## How to fix

Free space on the tablespace's filesystem. If the underlying filesystem does not support `posix_fallocate`, this points at a storage that PostgreSQL cannot preallocate on; check the disk and filesystem type. Resolve the space or storage problem and retry.

## Example

*Illustrative* — file extension failing on a full disk.

```text
ERROR:  could not extend file "base/16384/16400" with FileFallocate(): No space left on device
```

## Related

- [could not extend file: wrote only of bytes at block](./could-not-extend-file-wrote-only-of-bytes-at-block.md)
- [could not finalize checksum of file](./could-not-finalize-checksum-of-file.md)
