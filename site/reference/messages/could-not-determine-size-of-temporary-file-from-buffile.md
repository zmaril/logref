---
message: "could not determine size of temporary file \"%s\" from BufFile \"%s\": %m"
slug: could-not-determine-size-of-temporary-file-from-buffile
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/buffile.c:772"
  - "postgres/src/backend/storage/file/buffile.c:873"
reproduced: false
---

# `could not determine size of temporary file "%s" from BufFile "%s": %m`

## What it means

The server could not stat a temporary file backing a `BufFile` to learn its size. The placeholders are the file names and the system reason. Buffered temporary files (used by sorts, hashes, and parallel operations) rely on knowing their on-disk size, and that query failed.

## When it happens

A spill-to-disk operation when the underlying temporary file was removed out from under the server, the filesystem errors, or a shared temp file expected by parallel workers is missing.

## How to fix

Check the OS error in the detail. Ensure the temporary-file location is stable and not being cleaned by an external process, has free space, and is healthy. Confirm no external job deletes files under `pgsql_tmp`. Fix the storage or interference and retry.

## Example

*Illustrative* — a temp file whose size could not be read.

```text
ERROR:  could not determine size of temporary file "0.0" from BufFile "hashjoin": No such file or directory
```

## Related

- [could not create temporary file](./could-not-create-temporary-file.md)
- [could not extend file](./could-not-extend-file.md)
