---
message: "could not read from file set \"%s\": read only %zu of %zu bytes"
slug: could-not-read-from-file-set-read-only-of-bytes
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/buffile.c:630"
reproduced: false
---

# `could not read from file set "%s": read only %zu of %zu bytes`

## What it means

The shared buffered-file layer read from a file in a file set — the temporary storage parallel workers share — and received fewer bytes than expected. The counts show what was read against what was needed. The file is shorter than recorded.

## When it happens

It fires during a parallel operation (for example a parallel hash join or sort) that spills to a shared file set, when a read returns too few bytes — usually a temporary file removed out from under the query, a full temporary tablespace, or an I/O error.

## How to fix

Make sure the temporary tablespace (or `base/pgsql_tmp`) has free space and healthy storage, and that nothing outside Postgres deletes temporary files while queries run. Freeing space or fixing the storage lets the parallel query complete.

## Example

*Illustrative* — a short read from a shared file set.

```text
ERROR:  could not read from file set "i1of2.p0.0": read only 512 of 8192 bytes
```

## Related

- [could not open temporary file from BufFile](./could-not-open-temporary-file-from-buffile.md)
- [could not read from file: read instead of bytes](./could-not-read-from-file-read-instead-of-bytes.md)
