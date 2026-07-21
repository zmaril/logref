---
message: "could not clone file \"%s\" to \"%s\": %m"
slug: could-not-clone-file-to
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/copydir.c:243"
  - "postgres/src/backend/storage/file/copydir.c:274"
reproduced: false
---

# `could not clone file "%s" to "%s": %m`

## What it means

A server file-clone operation from one path to another failed. The placeholders are the source, destination, and system reason. The reflink-style copy could not be completed as requested.

## When it happens

An internal file clone (for example during certain copy operations) when the destination filesystem does not support cloning, the paths span different filesystems, or a permission or space error occurs.

## How to fix

Check the OS error in the detail. Ensure source and destination are on the same clone-capable filesystem, that there is enough free space, and that permissions allow writing the destination. Resolve the underlying filesystem issue and retry.

## Example

*Illustrative* — a failed file clone.

```text
ERROR:  could not clone file "base/16384/1" to "base/16385/1": Operation not supported
```

## Related

- [could not clone file between old and new data directories](./could-not-clone-file-between-old-and-new-data-directories.md)
- [could not extend file](./could-not-extend-file.md)
