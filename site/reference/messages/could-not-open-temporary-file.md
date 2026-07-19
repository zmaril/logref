---
message: "could not open temporary file \"%s\": %m"
slug: could-not-open-temporary-file
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:1901"
  - "postgres/src/bin/psql/command.c:4785"
reproduced: false
---

# `could not open temporary file "%s": %m`

## What it means

A temporary file could not be opened. The `%s` is the path and the `%m` is the operating-system error. On the server this is a spill file for sorts, hashes, or large results; in `psql` it is an editor or query temp file.

## When it happens

The temp directory was missing, full, or not writable, permissions were wrong, or the process hit a descriptor limit. It fires when a query spills to disk or when `psql` needs a scratch file.

## How to fix

Read the trailing error. Ensure the temp location (`temp_tablespaces` / the data directory's `base/pgsql_tmp`, or `TMPDIR` for `psql`) exists, is writable, and has free space. Raise limits if descriptors are exhausted.

## Example

*Illustrative* — the temp area was out of space.

```text
ERROR:  could not open temporary file "base/pgsql_tmp/pgsql_tmp1234.0": No space left on device
```

## Related

- [could not seek to block in temporary file](./could-not-seek-to-block-in-temporary-file.md)
- [exceeded maxAllocatedDescs while trying to open file](./exceeded-maxallocateddescs-while-trying-to-open-file.md)
