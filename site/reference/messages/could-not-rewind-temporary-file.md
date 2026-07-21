---
message: "could not rewind temporary file"
slug: could-not-rewind-temporary-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/backup/backup_manifest.c:355"
reproduced: false
---

# `could not rewind temporary file`

## What it means

Code that builds the backup manifest could not rewind a temporary file back to its start before reading it. Rewinding resets the file position to the beginning; the seek to offset zero failed.

## When it happens

It fires while a base backup assembles its manifest and needs to reread a temporary file it wrote, when repositioning that file to the start does not succeed.

## How to fix

This points at a problem with the temporary file's storage — an I/O error or a filesystem that mishandled the file. Check the disk holding the server's temporary files, look for errors in the kernel log, and rerun the backup. It is an infrastructure fault rather than a data problem.

## Example

*Illustrative* — a temporary file could not be rewound.

```text
ERROR:  could not rewind temporary file
```

## Related

- [could not seek in file to offset](./could-not-seek-in-file-to-offset.md)
- [could not update checksum](./could-not-update-checksum.md)
