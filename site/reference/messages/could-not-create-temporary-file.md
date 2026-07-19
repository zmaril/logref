---
message: "could not create temporary file \"%s\": %m"
slug: could-not-create-temporary-file
passthrough: false
api: [elog, ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:1828"
  - "postgres/src/backend/storage/file/fd.c:1865"
reproduced: false
---

# `could not create temporary file "%s": %m`

## What it means

The server could not create a temporary file used for spilling data to disk (for large sorts, hashes, or other operations that exceed `work_mem`). The placeholders are the path and the system reason. The temp file could not be opened for writing.

## When it happens

A query that spills to disk when the temporary-file location is out of space, has wrong permissions, hits a per-process file-descriptor limit, or the filesystem errors.

## How to fix

Check the OS error in the detail. Ensure the temp-file tablespace or `base/pgsql_tmp` location has free space and correct permissions, and that file-descriptor limits are adequate. Free disk space, or point `temp_tablespaces` at a location with room. Reducing the query's memory footprint can also lower temp-file demand.

## Example

*Illustrative* — a temp file that could not be created.

```text
ERROR:  could not create temporary file "base/pgsql_tmp/pgsql_tmp12345.0": No space left on device
```

## Related

- [could not determine size of temporary file from BufFile](./could-not-determine-size-of-temporary-file-from-buffile.md)
- [could not extend file](./could-not-extend-file.md)
