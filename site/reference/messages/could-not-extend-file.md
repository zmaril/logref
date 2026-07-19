---
message: "could not extend file \"%s\": %m"
slug: could-not-extend-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:525"
  - "postgres/src/backend/storage/smgr/md.c:647"
reproduced: false
---

# `could not extend file "%s": %m`

## What it means

The storage manager could not grow a relation's file to add a new block. The placeholders are the file and the system reason. Writing the new block past the current end of the file failed at the OS level.

## When it happens

Inserting or updating data that needs a new page when the filesystem holding the data directory is full, a disk quota is hit, or the device errors.

## How to fix

Check the OS error in the detail. Free disk space on the data directory's filesystem, raise or clear any quota, and confirm the device is healthy. `could not extend file: No space left on device` almost always means the volume is full; add space or remove data and retry.

## Example

*Illustrative* — a full filesystem preventing extension.

```text
ERROR:  could not extend file "base/16384/16789": No space left on device
```

## Related

- [cannot extend file beyond blocks](./cannot-extend-file-beyond-blocks.md)
- [could not create temporary file](./could-not-create-temporary-file.md)
