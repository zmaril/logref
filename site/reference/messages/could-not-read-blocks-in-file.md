---
message: "could not read blocks %u..%u in file \"%s\": %m"
slug: could-not-read-blocks-in-file
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:918"
  - "postgres/src/backend/storage/smgr/md.c:2075"
reproduced: false
---

# `could not read blocks %u..%u in file "%s": %m`

## What it means

A read of one or more data blocks from a relation file failed. The `%u..%u` is the block range, the `%s` is the file, and the `%m` is the operating-system error. The affected pages could not be brought into shared buffers.

## When it happens

The underlying storage returned an I/O error, the file was truncated or removed out from under the server, or a filesystem or device fault occurred while a query read those blocks.

## How to fix

Read the trailing error and check the storage device and filesystem for faults (kernel logs, SMART data). Restore the affected relation from backup if the medium is damaged. Persistent read errors mean failing hardware.

## Example

*Illustrative* — an I/O error reading data blocks.

```text
ERROR:  could not read blocks 100..107 in file "base/16384/16390": Input/output error
```

## Related

- [could not read blocks in file: read only of bytes](./could-not-read-blocks-in-file-read-only-of-bytes.md)
- [could not seek in file](./could-not-seek-in-file.md)
